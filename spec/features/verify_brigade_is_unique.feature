Feature: Brigade form only allows cities without a Brigade to create a new one
 
  As a user
  I would like to get an error in real time if I try to create a Brigade in a city that already has one
  So that multiple Brigades don't get created for the same city
  
#  Background: Brigades in database
#
#     Given the following brigades exist:
#      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
#      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |
#
#  Scenario: Try to create another Monterrey Brigade
#    pending
#
#    Given I type "Monterrey" into the fuzzy search text box for Brigade location
#    When I select the city "Monterrey | Nuevo León"
#    Then the box around the location text box border should turn red
#    And a message should pop up below the text box displaying the text: "A brigade already exists in Monterrey"
#
#  Scenario: Try to press submit with invalid city selected
#    pending
#
#    Given I type "Monterrey" into the fuzzy search text box for Brigade location
#    And I select the city "Monterrey" from the drop down list
#    And the Location text box border is red
#    And I try to press the submit button
#    Then The submit button should not be clickable until a valid city is entered
#
#  Scenario: Create a new valid Brigade in a new town
#    pending
#
#    Given I type "Xico" into the fuzzy serach text box for Brigade location
#    Then the Location text box border should not be red
#    And there should be no text under the Location text box
#
#
#