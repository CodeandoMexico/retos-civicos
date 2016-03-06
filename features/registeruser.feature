Feature: register a user

    As a user (citizen/org/government)
    I want to register
    So that I can have a personalized experience on CM
    
Scenario: correctly register a user
  
  Given I am on the user registration page
  When  I fill in the fields: e-mail: "johnnyappleseed@example.com", username: "johnnyapples", password: "or@nges4me"
  And   I press "Registra usuario"
  Then  I should be on the registration success page
  And   The user "johnnyapples" should be in the database