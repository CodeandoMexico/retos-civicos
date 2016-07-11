$(window).load ->
  if window.currentController == "brigades" && window.currentAction == "index"
    brigadeMap = ''
    geocodeCache = {}
    markers = []
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
      addBrigadeSearchCallback document.getElementById('brigade-query'), execLocationSearch, 1000

    formatLocName = (data) ->
      console.log(data)
      data['address_components'][0]['long_name'] + ", " + data['address_components'][2]['long_name']

    recenterMap = (data, brigadeDiv) ->
      brigadeMap.panTo data.geometry.location
      marker = new (google.maps.Marker)(
        map: brigadeMap
        position: data.geometry.location
        icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png')
      markers.push(marker)
      locationName = formatLocName(data)
      $('.detail-text').text(locationName)
      if brigadeDiv != undefined
        $(brigadeDiv).find('.brigade-location').first().text(data['address_components'][0]['short_name'] + ", " + data['address_components'][2]['short_name'])
        $(brigadeDiv).find('.brigade-title-text').first().text(data['address_components'][0]['short_name'])
      marker.addListener 'click', ->
        brigadeMap.panTo marker.getPosition()
        $('.detail-text').text(locationName)
        return

    codeAddress = (state, city, successFn) ->
      address = city.toLowerCase() + ", " + state.toLowerCase()
      if (geocodeCache[address] != undefined)
        data = geocodeCache[address]
        recenterMap(data)
      else
        geocoder = new (google.maps.Geocoder)
        geocoder.geocode { 'address': address, 'region': 'mx' }, (results, status) ->
          if status == google.maps.GeocoderStatus.OK
            geocodeCache[address] = results[0]
            if successFn != undefined && successFn != null
              successFn(results[0])
          else
            console.log 'Geocode was not successful for the following reason: ' + status
            return
          return

    appendBrigadeCard = (state, city, color, num_members, brigade_since, header_img, brigadeId, index, is_last) ->
      address = city.toLowerCase() + ", " + state.toLowerCase()
      data = geocodeCache[address]
      brigadeResultsDiv = $('#brigade-results')
      if index % 4 == 0
        brigadeResultsDiv.append("<div class='row brigade-row'>")
      brigadeResultsDiv.append("<a href='/brigades/#{brigadeId}'>
        <div class='brigade col-md-3' data-city='#{data['address_components'][0]['short_name']}' data-state='#{data['address_components'][2]['short_name']}'>
        <div class='brigade-title-container' id='brigade-title-container'>
        <div class='brigade-img' style='background-image: url(#{header_img})'>
        <div class='translucent-overlay'>
        <h2 class='brigade-title-text'>#{data['address_components'][0]['short_name']}</h2>
        </div></div></div>
        <div class='brigade-detail' style='background-color: #{color}'>
        <div class='brigade-location'>#{data['address_components'][0]['short_name']}, #{data['address_components'][2]['short_name']}</div>
        <div class='members'>#{num_members}</div>
        <div class='founded'>#{brigade_since}</div>
        </div></div>")
      if index % 4 == 3 || is_last
        brigadeResultsDiv.append('</div>')

    resetBrigades = ->
      $('#brigade-results').empty()
      $('#detail-text').empty()
      deleteMarkers()

    setMapOnAll = (map) ->
      i = 0
      while i < markers.length
        markers[i].setMap map
        i++
      return

    clearMarkers = ->
      setMapOnAll null
      return

    deleteMarkers = ->
      clearMarkers()
      markers = []
      return

    populateBrigades = (brigades) ->
      i = 0
      if brigades.message != undefined
        $('#brigade-results').append("<h1>#{brigades.message}</h1>")
        return
      while i < brigades.length
        state = brigades[i].state
        city = brigades[i].city
        color = brigades[i].color
        num_members = brigades[i].num_hackers
        brigade_since = brigades[i].brigade_since
        header_img = brigades[i].header_image_url
        brigadeId = brigades[i].id
        is_last = i == brigades.length-1
        appendBrigadeCard(state, city, color, num_members, brigade_since, header_img, brigadeId, i, is_last)
        codeAddress(state, city, recenterMap)
        i++
      setBrigadeHoverListeners()

    execLocationSearch = ->
      $.ajax
        url: '/brigade_search/' + $("#brigade-query").val()
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          resetBrigades()
          console.log("BING")
          populateBrigades(data)

    addBrigadeSearchCallback = (textArea, callback, delay) ->
      timer = null
      textArea.onkeyup = ->
        if timer
          window.clearTimeout timer
        timer = window.setTimeout((->
          timer = null
          callback()
        ), delay)
      textArea = null

    setup()