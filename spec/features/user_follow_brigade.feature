Feature: User should be able to follow a brigade

  As a user
  I want to be able to follow a brigade
  So that I can stay updated on events in my area and feel like a part of the community
  
  Background: Brigades in database
    
    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |
    
    Given the following users exist:
      | email          | password |
      | test1@test.com | 111111   |
      | test2@test.com | 123456   |
      | test3@test.com | 111111   |
    
    Given the following users are in brigade Monterrey, Nuevo León:
      | email          | name  | password |
      | test1@test.com | Kyle  | 111111   |
  
    Scenario: Able to follow a Brigade when logged in
      Given I am logged in as the user with email: 'test1@test.com'
    #   And I am not following Monterrey, Nuevo León
    #   When I visit the brigade page for Monterrey, Nuevo León
    #   Then I should see translation for "brigades.follow.follow"
      
    #   When I click "Unirse"
    #   Then I am following Monterrey, Nuevo León
    #   And I can RSVP to an event

    # Scenario: Redirected to login when not logged in and try to join a brigade.
    #   Given I am not logged in as a user
    #   When I visit the brigade page for Monterrey, Nuevo León
    #   And I click "Unirse"
    #   Then I should be on the login page
      
    # Scenario: Should not see the join button if already in a brigade
    #   Given I am logged in as a user
    #   And I am following Monterrey, Nuevo León
    #   Then I should not see "Unirse"