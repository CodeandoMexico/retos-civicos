Feature: Brigade organizer should be able to edit a brigade project.

  As a brigade organizer
  I want to be able to edit a project that belongs to the brigade
  So that the projects representation can be changed as time elapses.

  Background: Brigades in database

    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

    Given the following projects exist in brigade Monterrey, Nuevo León:
      | title     |
      | test-proj |
    
    Given the following users are in brigade Monterrey, Nuevo León:
      | email          | name  | password |
      | test1@test.com | Kyle  | 111111   |
      | test2@test.com | Boss  | 111111   |

  Scenario: Not able to edit project when not logged in as organizer
    Given I am logged in as the user with email "test2@test.com" and name "Boss"
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should not see translation for "projects.edit"

  Scenario: Able to see edit project text when logged in as organizer
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see translation for "projects.edit"