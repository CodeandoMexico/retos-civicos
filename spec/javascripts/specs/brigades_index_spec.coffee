describe 'brigades_index', ->

  describe 'fuzzy search', ->
    ajaxSpy = ''
    locationSearch = ''
    beforeEach ->
      ajaxSpy = spyOn($, "ajax")
      locationSearch = $('.location-search')

    describe 'user types in a valid brigade with members', ->
      it 'should create brigade divs for results returned by ajax call', ->
        ajaxSpy.andReturn({
          data: {
            hasBrigades: "true"
            errorMessage: ""
            brigades: [
              {
                id: 1
                city: "Tequila"
                state: "Jalisco"
                longitude: "20.9"
                latitude: "103.8"
                memberText: '3 members'
                members: [
                  {
                    name: "Kyle Boss"
                    subtext: "(Organizer)"
                  }
                  {
                    name: "Barack Obama"
                    subtext: "4 projects in common"
                  }
                  {
                    name: "Enrique Nieto"
                    subtext: "2 brigades in common"
                  }
                ]
              }
            ]
          }
        })
        locationSearch.sendKeys('Tequila')
        tequilaDiv = $('.brigade').first
        tequilaMembers = $('.members', tequilaDiv)
        membersModal = $('#members-modal')
        expect($('.brigade').length).toEqual 1
        expect($('.city', tequilaDiv).text).toEqual("Tequila")
        expect($('.state', tequilaDiv).text).toEqual("Jalisco")
        expect(tequilaDiv).toHaveAttr('data-longitude', '20.9')
        expect(tequilaDiv).toHaveAttr('data-latitude', '103.8')
        expect(tequilaMembers.text).toEqual("3 members")

        describe 'members pop-up within brigade div created by ajax', ->

          beforeEach ->
            tequilaMembers.trigger('mouseover')

          it 'should appear when members text is hovered over', ->
            expect(monterreyMembersPopOver).toBeVisible

          it 'should disappear when mouse leaves members text', ->
            tequilaMembers.trigger('mouseleave')
            expect(monterreyMembersPopOver).toBeHidden

        describe 'members modal', ->

          it 'should appear and have member\'s name when members text is clicked', ->
            tequilaMembers.click
            expect(membersModal).toBeVisible
            memberNames = $('.members .member-name', membersModal)
            memberSubtexts = $('.members .subtext', membersModal)
            expect(memberNames[0]).toEqual("Kyle Boss")
            expect(memberSubtexts[0]).toEqual("(Organizer)")
            expect(memberNames[1]).toEqual("Barack Obama")
            expect(memberSubtexts[1]).toEqual("4 projects in common")
            expect(memberNames[2]).toEqual("Enrique Nieto")
            expect(memberSubtexts[2]).toEqual("2 brigades in common")

    describe 'user types in a valid brigade that has no members', ->
      it 'should create brigade divs for results returned by ajax call, but with no members', ->
        ajaxSpy.andReturn({
          data: {
            hasBrigades: "true"
            errorMessage: ""
            brigades: [
              {
                id: 1
                city: "Tequila"
                state: "Jalisco"
                longitude: "20.9"
                latitude: "103.8"
                memberText: 'Be the first to join!'
                members: []
              }
            ]
          }
        })
        locationSearch.sendKeys('Tequila')
        tequilaDiv = $('.brigade').first
        tequilaMembers = $('.members', tequilaDiv)
        expect(tequilaMembers.text).toEqual('Be the first to join!')

        describe 'members pop-up within brigade div created by ajax', ->

          it 'should not appear when members text is hovered over', ->
            tequilaMembers.trigger('mouseover')
            expect(monterreyMembersPopOver).toBeHidden

        describe 'members modal', ->

          it 'should not appear', ->
            tequilaMembers.click
            expect($('#members-modal')).toBeHidden

    describe 'user type in a query that returns no brigades', ->
      it  'should display a message declaring no brigades have been found', ->
        ajaxSpy.andReturn({
          data: {
            hasBrigades: "false"
            errorMessage: "No brigades match search. Try typing in a valid city/state."
            brigades: [ ]
          }
        })
        locationSearch.sendKeys('Abc123def456')


  describe 'brigade divs', ->

    googleMap = ''
    monterreyBrigade = ''
    monterreyMembers = ''

    beforeEach ->
      googleMap = jasmine.createSpy(google.maps, 'maps')
      googleMap.createSpy(setCenter, 'setCenter')
      googleMap.createSpy(LatLng, 'LatLng').andReturn('LatLng')
      loadFixtures('brigades_page.html')
      monterreyBrigade = $('.brigade').first()
      monterreyMembers = $('.members', monterreyBrigade)

    describe 'hover over brigade', ->

      beforeEach ->
        monterreyBrigade.trigger('mouseover')

      it 'should set the map\'s center to the brigade location', ->
        expect(googleMap.LatLng.toHaveBeenCalledWith('100.3', '25.7'))
        expect(googleMap.setCenter.toHaveBeenCalledWith('LatLng'))

      it 'should not change if mouse leaves brigades (only when it enters a new one)', ->
        googleMap.setCenter.calls.reset
        monterreyBrigade.trigger('mouseleave')
        expect(googleMap.setCenter.not.toHaveBeenCalled)

    describe 'hover over members text', ->

      monterreyMembersPopOver = ""
      beforeEach ->
        monterreyMembersPopOver = monterreyBrigade.find('.pop-over-results')
        monterreyMembers.trigger('mouseover')

      it 'should display the members pop-over', ->
        expect(monterreyMembersPopOver).toBeVisible

      it 'should stop displaying when the mouse leaves the members pop-over', ->
        monterreyMembers.trigger('mouseleave')
        expect(monterreyMembersPopOver).toBeHidden

    describe 'click on members text', ->

      membersModal = ""
      beforeEach ->
        membersModal = $('.members-modal')

      it 'should appear', ->
        monterreyMembers.click()
        expect(membersModal).toBeVisible