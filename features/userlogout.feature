Feature: logout as a user
    
    As a user
    I want to logout
    So that I can use CM on public machines

Background: users in database

  Given the following users exist:
  | email                        | username  | password |
  | johnnyappleseed@example.com  | johnnya   | 2Apples  |
  | chester@example.com          | coder123  | bananas  |

Scenario: logout correctly
  Given I am logged in as: "johnnya"
  And   I am on the user dashboard page of: "johnnya"
  When  I press "Logout"
  Then  I should be on the logout success page
  And   I should not be able to reach the user dashboard page