# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(window).load ->
  if window.currentController == "brigades"
    $('body').on 'click', 'div[class=location-list-option]', ->
      $("#location-query").val("#{$(this).data('city')}, #{$(this).data('state')}")
      $('#location-list').empty()
      $('#brigade_location_id').val($(this).data("location-id"))
      return

    do_location_search = ->
      $.ajax
        url: '/location_search/' + $("#location-query").val()
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          $('#location-list').empty()
          $('#brigade_location_id').val("")
          i = 0
          while i < data.length
            state = data[i].state
            city = data[i].city
            location_id = data[i].searchable_id
            $('#location-list').append("<div data-state='#{state}' data-city='#{city}'
              data-location-id='#{location_id}' class='location-list-option'>
              <span class='city'>#{city}</span><span class='divider'>|</span>
              <span class='state'>#{state}</span></div>")
            i++

    addLocationCallback = (textArea, callback, delay) ->
      timer = null

      textArea.onkeyup = ->
        if timer
          window.clearTimeout timer
        timer = window.setTimeout((->
          timer = null
          callback()
          return
        ), delay)
        return

      textArea = null
      return

    isNormalInteger = (str) ->
      n = ~~Number(str)
      String(n) == str and n >= 0

    setInitialLocation = ->
      location_id = $('#brigade_location_id').val()
      if isNormalInteger(location_id)
        $.get("/location_name/#{location_id}", (data) ->
          $("#location-query").val(data.data)
        )

    setFooterMargin = ->
      brigades = $("#brigades")
      footer = $("#footer")
      brigades_height = brigades.height()
      footer.css('top', brigades_height+150)
      footer.css('position', 'absolute')
      footer.css('width', '100%')

    $( window ).resize ->
      setFooterMargin()
      return

    styleArray = [
      {
        'featureType': 'all'
        'elementType': 'labels.text'
        'stylers': [ { 'color': '#a1f7ff' } ]
      }
      {
        'featureType': 'all'
        'elementType': 'labels.text.fill'
        'stylers': [ { 'color': '#ffffff' } ]
      }
      {
        'featureType': 'all'
        'elementType': 'labels.text.stroke'
        'stylers': [
          { 'color': '#000000' }
          { 'lightness': 13 }
        ]
      }
      {
        'featureType': 'administrative'
        'elementType': 'geometry.fill'
        'stylers': [ { 'color': '#000000' } ]
      }
      {
        'featureType': 'administrative'
        'elementType': 'geometry.stroke'
        'stylers': [
          { 'color': '#144b53' }
          { 'lightness': 14 }
          { 'weight': 1.4 }
        ]
      }
      {
        'featureType': 'administrative'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'administrative.province'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'administrative.locality'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'administrative.neighborhood'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'landscape'
        'elementType': 'all'
        'stylers': [ { 'color': '#08304b' } ]
      }
      {
        'featureType': 'poi'
        'elementType': 'geometry'
        'stylers': [
          { 'color': '#0c4152' }
          { 'lightness': 5 }
        ]
      }
      {
        'featureType': 'poi.attraction'
        'elementType': 'labels'
        'stylers': [ { 'invert_lightness': true } ]
      }
      {
        'featureType': 'poi.attraction'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'poi.park'
        'elementType': 'labels'
        'stylers': [
          { 'visibility': 'on' }
          { 'invert_lightness': true }
        ]
      }
      {
        'featureType': 'poi.park'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'road'
        'elementType': 'labels.text'
        'stylers': [ { 'color': '#a1f7ff' } ]
      }
      {
        'featureType': 'road.highway'
        'elementType': 'geometry.fill'
        'stylers': [ { 'color': '#000000' } ]
      }
      {
        'featureType': 'road.highway'
        'elementType': 'geometry.stroke'
        'stylers': [
          { 'color': '#0b434f' }
          { 'lightness': 25 }
        ]
      }
      {
        'featureType': 'road.highway'
        'elementType': 'labels'
        'stylers': [
          { 'lightness': '0' }
          { 'saturation': '0' }
          { 'invert_lightness': true }
          { 'visibility': 'simplified' }
          { 'hue': '#00e9ff' }
        ]
      }
      {
        'featureType': 'road.highway'
        'elementType': 'labels.text'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'color': '#a1f7ff' }
        ]
      }
      {
        'featureType': 'road.highway.controlled_access'
        'elementType': 'labels.text'
        'stylers': [ { 'color': '#a1f7ff' } ]
      }
      {
        'featureType': 'road.arterial'
        'elementType': 'geometry.fill'
        'stylers': [ { 'color': '#000000' } ]
      }
      {
        'featureType': 'road.arterial'
        'elementType': 'geometry.stroke'
        'stylers': [
          { 'color': '#0b3d51' }
          { 'lightness': 16 }
        ]
      }
      {
        'featureType': 'road.arterial'
        'elementType': 'labels'
        'stylers': [ { 'invert_lightness': true } ]
      }
      {
        'featureType': 'road.local'
        'elementType': 'geometry'
        'stylers': [ { 'color': '#000000' } ]
      }
      {
        'featureType': 'road.local'
        'elementType': 'labels'
        'stylers': [
          { 'visibility': 'simplified' }
          { 'invert_lightness': true }
        ]
      }
      {
        'featureType': 'transit'
        'elementType': 'all'
        'stylers': [ { 'color': '#146474' } ]
      }
      {
        'featureType': 'water'
        'elementType': 'all'
        'stylers': [ { 'color': '#021019' } ]
      }
    ]

    initializeMap = ->
      mapProp =
        center: new (google.maps.LatLng)(51.508742, -0.120850)
        zoom: 5
        styles: styleArray
        scrollwheel: false
        disableDefaultUI: true
        navigationControl: false
        mapTypeControl: false
        scaleControl: false
        draggable: false
        mapTypeId: google.maps.MapTypeId.ROADMAP
      map = new (google.maps.Map)(document.getElementById('googleMap'), mapProp)
      return

    initializeMap()
    setInitialLocation()
    setFooterMargin()
    addLocationCallback document.getElementById('location-query'), do_location_search, 1000