$(window).load ->
  if window.currentController == "brigades" && window.currentAction == "index"
    brigadeMap = ''
    geocodeCache = {}
    initMap = ->
      brigadeMap = new (google.maps.Map)(document.getElementById('brigade-map'),
        center:
          lat: 23.3652322
          lng: -107.0840754
        zoom: 5
        styles: window.googleMapStyleArray
        scrollwheel: false)
      return

    setBrigadeHoverListeners = ->
      $('.brigade').hover (->
        city = $(this).attr('data-city')
        state = $(this).attr('data-state')
        codeAddress(state, city)
        return
      ), ->
      $(this).css 'background-color', '#000'
      return

    setOriginalMarkers = ->
      codeAddress('monterrey, nuevo león')
      codeAddress('tequila, jalisco')
      codeAddress('puerto vallarta, jalisco')
      codeAddress('veracruz, veracruz')

    setup = ->
      initMap()
      setBrigadeHoverListeners()
      setOriginalMarkers()

    recenterMap = (data, color='FF0000') ->
      brigadeMap.panTo data.geometry.location
      marker = new (google.maps.Marker)(
        map: brigadeMap
        position: data.geometry.location
        icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png')
      locationName = data['address_components'][0]['short_name'] + ", " + data['address_components'][2]['short_name']
      $('.detail-text').text(locationName)
      marker.addListener 'click', ->
        brigadeMap.panTo marker.getPosition()
        $('.detail-text').text(locationName)
        return

    codeAddress = (state, city, color) ->
      address = city + ", " + state
      if (geocodeCache[address] != undefined)
        data = geocodeCache[address]
        recenterMap(data, color)
      else
        geocoder = new (google.maps.Geocoder)
        geocoder.geocode { 'address': address, 'region': 'mx' }, (results, status) ->
          if status == google.maps.GeocoderStatus.OK
            geocodeCache[address] = results[0]
            console.log(results[0])
            recenterMap(results[0], color)
          else
            console.log 'Geocode was not successful for the following reason: ' + status
            return
          return

    setup()