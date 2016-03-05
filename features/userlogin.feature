Feature: login as a user
    
    As a user
    I want to login
    So that I may participate in social activities provided by CodeandoMexico

Background: users in database

  Given the following users exist:
  | email                        | username  | password |
  | johnnyappleseed@example.com  | johnnya   | 2Apples  |
  | chester@example.com          | coder123  | bananas  |

Scenario: login correctly
  Given I am on the login page
  When  I fill in the fields: e-mail: "johnnyappleseed@example.com", password: "2Apples"
  And   I press "Login"
  Then  I should be on the user dashboard page of: "johnnya"

Scenario: login failure
  Given I am on the login page
  When  I fill in the fields: e-mail: "johnnyappleseed@example.com", password: "Apples2"
  And   I press "Login"
  Then  I should be on the login page
  And   I should see "Invalid login credentials"