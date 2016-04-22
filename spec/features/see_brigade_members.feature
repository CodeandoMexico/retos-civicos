Feature: User should be able to see brigade members
    As a user
    I want to be able to see all members of a brigade
    So that I can know who is in my community
  
  Background: Brigades in database
    
    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |
    
    Given the following users exist:
      | email          | password |
      | test1@test.com | 111111   |
      | test2@test.com | 123456   |
      | test3@test.com | 111111   |
  
    Scenario: Able to see correct members when "See All Members" button is clicked
      Given the following users are in brigade Monterrey, Nuevo León:
      | email          | name  | password |
      | test1@test.com | Kyle  | 111111   |
      | test2@test.com | Jake  | 123456   |
      And I am logged in as the user with email: test2@test.com
      When I visit the brigade page for Monterrey, Nuevo León
      Then I should see translation for "brigades.show.members.see_all_members"
      
      When I click on the translation for "brigades.show.members.see_all_members"
      Then I should see "Kyle"
      And  I should see "Jake"
      And  I should not see "Adrian"
    Scenario: If there are no followers, I should still see the organizer
      Given I am logged in as the user with email: test2@test.com
      When I visit the brigade page for Monterrey, Nuevo León
      Then I should see translation for "brigades.show.members.see_all_members"
      
      When I click on the translation for "brigades.show.members.see_all_members"
      Then I should not see "Kyle"
      And  I should not see "Jake"
      And  I should see the brigade organizer