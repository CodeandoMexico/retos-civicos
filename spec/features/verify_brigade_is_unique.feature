Feature: Brigade form only allows cities without a Brigade to create a new one
 
  As a user
  I would like to get an error in real time if I try to create a Brigade in a city that already has one
  So that multiple Brigades don't get created for the same city
  
  Background: Brigades in database
    
     Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

  Scenario: Try to create another Monterrey Brigade
    Given I am logged in as a user
    When I visit the create brigade page
    And I type Monterrey into the fuzzy search text box
    Then I can select the city Monterrey
    
  Scenario: Create a new valid Brigade in a new town
    Given I am logged in as a user
    When I visit the create brigade page
    And I type Xico into the fuzzy search text box
    When I can select the city Xico
    
    
    
    
