Feature: Home page should have particular elements

  As a user
  I would like to be able to get to the brigades page from the header bar
  so I can easily navigate to a list of brigades without typing in a URL.

  Background: Brigades in database

  Scenario: Go to home page as not logged in user
    When I visit the home page
    And I click on "Participa"
    Then I should see translation for "brigades.brigades"

  Scenario: Go to home page as logged in user
    Given I am logged in as a user
    When I visit the home page
    And I click on "Participa"
    Then I should see translation for "brigades.brigades"




