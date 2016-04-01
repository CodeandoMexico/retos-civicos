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


    setInitialLocation()

    addLocationCallback document.getElementById('location-query'), do_location_search, 1000