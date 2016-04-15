$(window).load ->
  if window.currentController == "brigades"
    if window.currentAction == "new" || window.currentAction == "edit"

      addLocationToLocationList = (state, city, locationId) ->
        $('#location-list').append("<div data-state='#{state}' data-city='#{city}'
                data-location-id='#{locationId}' class='location-list-option'>
                <span class='city'>#{city}</span><span class='divider'>|</span>
                <span class='state'>#{state}</span></div>")

      resetLocation = ->
        $('#location-list').empty()
        $('#brigade_location_id').val("")

      populateLocations = (locations) ->
        i = 0
        while i < locations.length
          state = locations[i].state
          city = locations[i].city
          locationId = locations[i].searchable_id
          addLocationToLocationList(state, city, locationId)
          i++

      execLocationSearch = ->
        $.ajax
          url: '/location_search/' + $("#location-query").val()
          type: 'GET'
          dataType: 'json'
          success: (data) ->
            resetLocation()
            populateLocations(data)

      addLocationCallback = (textArea, callback, delay) ->
        timer = null
        textArea.onkeyup = ->
          if timer
            window.clearTimeout timer
          timer = window.setTimeout((->
            timer = null
            callback()
          ), delay)
        textArea = null

      isNormalInteger = (str) ->
        n = ~~Number(str)
        String(n) == str and n >= 0

      setInitialLocation = ->
        location_id = $('#brigade_location_id').val()
        if isNormalInteger(location_id)
          $.get("/location_name/#{location_id}", (data) ->
            $("#location-query").val(data.data)
          )

      removeLocationListWhenBodyClicked = ->
        $('body').on 'click', 'div[class=location-list-option]', ->
          $("#location-query").val("#{$(this).data('city')}, #{$(this).data('state')}")
          $('#location-list').empty()
          $('#brigade_location_id').val($(this).data("location-id"))
          return
          
      checkIfNewLocationOnClick = ->
        $('body').on 'click', 'div[class=location-list-option]', ->
          location_id = $('#brigade_location_id').val()
          $.get("/location_unique/#{location_id}", (data) ->
            if (data.data)
              $("#location-query").css("outline","#f66 auto 5px");
            else
              $("#location-query").css("outline","none");
          )
          return
          
      slackValidation = ->
        $('body').on 'focusout', '#brigade_slack_url', ->
          $("#brigade_calendar_url").val($("#brigade_calendar_url").val())
          if  $("#brigade_slack_url").val() == ""
            $("#brigade_slack_url").css("outline","#f66 auto 5px");
          else
            $("#brigade_slack_url").css("outline","none");
            
      githubValidation = ->
        $('body').on 'focusout', '#brigade_github_url', ->
          $("#brigade_calendar_url").val($("#brigade_calendar_url").val())
          if  $("#brigade_github_url").val() == ""
            $("#brigade_github_url").css("outline","#f66 auto 5px");
          else
            $("#brigade_github_url").css("outline","none");
            
       facebookValidation = ->
        $('body').on 'focusout', '#brigade_facebook_url', ->
          $("#brigade_calendar_url").val($("#brigade_calendar_url").val())
          if  $("#brigade_facebook_url").val() == ""
            $("#brigade_facebook_url").css("outline","#f66 auto 5px");
          else
            $("#brigade_facebook_url").css("outline","none");

      twitterValidation = ->
        $('body').on 'focusout', '#brigade_twitter_url', ->
          $("#brigade_calendar_url").val($("#brigade_calendar_url").val())
          if  $("#brigade_twitter_url").val() == ""
            $("#brigade_twitter_url").css("outline","#f66 auto 5px");
          else
            $("#brigade_twitter_url").css("outline","none");
      setup = ->
        addLocationCallback document.getElementById('location-query'), execLocationSearch, 1000
        removeLocationListWhenBodyClicked()
        setInitialLocation()
        checkIfNewLocationOnClick()
        slackValidation()
        githubValidation()
        facebookValidation()
        twitterValidation()
        

      setup()
  
hello = ->
  $("#brigade_calendar_url").css("outline","red solid 3px");
  
  
