Feature: Brigade form informs the user whether the entered URL is valid or not
 
  As a user
  I would like to get feedback in real time if I enter a URL on the Brigade Nuevo page 
  So that my Brigade page can be error free when it is created
  
  Background: Brigades in database
    
     Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

  Scenario: Try to create a Brigade with one of the text boxes filled in with: "hi.com"
    pending
    
    Given I type "hi.com" into the one of the text boxes (Calendar, Slack, Twitter, Facebook, Github)
    And I click away from this text box
    Then the border around the text box should turn red
    And a message should pop up below the text box saying: "Please enter a valid URL"
    
  Scenario: Try to create a Brigade with the text box filled in correctly
    pending
    
    Given I type a valid URL into a text box
    And I click away from this text box
    Then the border around the text box should turn green
    
    
 
    
    