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
      $('.brigade').each ->
        brigade = $(this)
        codeAddress(brigade.attr('data-state'), $(this).attr('data-city'), (data) -> recenterMap(data, brigade) )

    setup = ->
      initMap()
      setBrigadeHoverListeners()
      setOriginalMarkers()

    formatLocName = (data) ->
      data['address_components'][0]['long_name'] + ", " + data['address_components'][2]['long_name']

    recenterMap = (data, brigadeDiv) ->
      brigadeMap.panTo data.geometry.location
      marker = new (google.maps.Marker)(
        map: brigadeMap
        position: data.geometry.location
        icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png')
      locationName = formatLocName(data)
      $('.detail-text').text(locationName)
      if brigadeDiv != undefined
        console.log brigadeDiv
        $(brigadeDiv).find('.brigade-location').first().text(locationName)
        $(brigadeDiv).find('.brigade-title-text').first().text(data['address_components'][0]['short_name'])
      marker.addListener 'click', ->
        brigadeMap.panTo marker.getPosition()
        $('.detail-text').text(locationName)
        return

    codeAddress = (state, city, successFn) ->
      address = city + ", " + state
      if (geocodeCache[address] != undefined)
        data = geocodeCache[address]
        recenterMap(data)
      else
        geocoder = new (google.maps.Geocoder)
        geocoder.geocode { 'address': address, 'region': 'mx' }, (results, status) ->
          if status == google.maps.GeocoderStatus.OK
            geocodeCache[address] = results[0]
            successFn(results[0])
          else
            console.log 'Geocode was not successful for the following reason: ' + status
            return
          return

    setup()