$(window).load ->
  if window.currentController == "brigades"
    if window.currentAction == "show"

      googleMapProperties = (center) ->
        center: center
        zoom: 5
        styles: window.googleMapStyleArray
        scrollwheel: false
        disableDefaultUI: true
        navigationControl: false
        mapTypeControl: false
        scaleControl: false
        mapTypeId: google.maps.MapTypeId.ROADMAP

      initializeMap = ->
        center = new (google.maps.LatLng)(51.508742, -0.120850)
        new (google.maps.Map)(document.getElementById('googleMap'), googleMapProperties(center))

      setPopOverListeners = ->
        $('.pop-over-subject').hover (->
          $(this).find('.pop-over-results').css('display', 'block')
        ), ->
          $(this).find('.pop-over-results').css('display', 'none')

      setDatePickers = ->
        cb = (start, end) ->
          $('#event-date-range span').html start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')

        cb moment().subtract(29, 'days'), moment()
        $('#event-date-range').daterangepicker { ranges: window.dateRanges }, cb

      executeSVGSwaps = ($img, imgID, imgClass, imgURL) ->
        jQuery.get imgURL, ((data) ->
          $svg = jQuery(data).find('svg')
          if typeof imgID != 'undefined'
            $svg = $svg.attr('id', imgID)
          if typeof imgClass != 'undefined'
            $svg = $svg.attr('class', imgClass + ' replaced-svg')
          $svg = $svg.removeAttr('xmlns:a')
          $img.replaceWith $svg
        ), 'xml'

      giveSVGImgsFillAttributes = ->
        $('img.svg').each ->
          $img = jQuery(this)
          imgID = $img.attr('id')
          imgClass = $img.attr('class')
          imgURL = $img.attr('src')
          executeSVGSwaps($img, imgID, imgClass, imgURL)

      setup = ->
        giveSVGImgsFillAttributes()
        initializeMap()
        setPopOverListeners()
        setDatePickers()

      setup()