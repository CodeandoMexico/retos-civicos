Feature: Brigade organizer should be able to edit a brigade project.

  As a brigade organizer
  I want to be able to edit a project
  So I can change its information as requirements change.

  Background: Brigades in database

    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

    Given the following users are in brigade Monterrey, Nuevo León:
      | email          | name  | password |
      | test1@test.com | Kyle  | 111111   |
      | test2@test.com | Boss  | 111111   |

    Given the following projects exist in brigade Monterrey, Nuevo León:
      | title               | description                                   | tags                    |
      | handy dandy project | This is the best project ever.                | ruby, scheme, marketing |

  Scenario: Not able to edit project when not logged in as organizer
    Given I am logged in as the user with email "test2@test.com" and name "Boss"
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should not see translation for "projects.edit"

  Scenario: Able to see edit project text when logged in as organizer
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see the translation for "projects.edit" within ".projects-panel"

  Scenario: Fields are properly filled in initially when edit is clicked
#    Given PENDING: don't know how to select tags
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    And I click on the translation for "projects.edit" within ".projects-panel"
    Then field "brigade_project[title]" should be filled in with "handy dandy project"
    And field "brigade_project[description]" should be filled in with "This is the best project ever."
    And field "brigade_project[tags]" should contain the values "ruby, scheme, marketing"
    And the button with translation "projects.update" should exist
    And the button with translation "projects.update" should be enabled


  Scenario: Able to edit project when logged in as organizer
    Given PENDING: don't know how to select tags
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    And I click on the translation for "projects.edit" within ".projects-panel"
    And I fill in "brigade_project[title]" with "Semaforos"
    And I fill in "brigade_project[description]" with "Vamos a mejorar las calles de Mexico!"
    And I fill in ".tags-input-container/input" with "scheme, Ruby, JAVA"
    And I click on the translation for "projects.update"
    Then I should see translation for "projects.successfully_updated"
    And the tags "scheme, ruby, java" should exist
    And there should only be 4 tags
    And the project "Semaforos" should exist in brigade "Monterrey, Nuevo León"
    And the project "Semaforos" in brigade "Monterrey, Nuevo León" should have the tags "scheme, ruby, java"
    And the project "Semaforos" in brigade "Monterrey, Nuevo León" should have the description "Vamos a mejorar las calles de Mexico!"
    And the project "handy dandy project" should not exist in brigade "Monterrey, Nuevo León"

  Scenario: Should not be able to add a project with an empty title
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    And I click on the translation for "projects.edit" within ".projects-panel"
    And I fill in "brigade_project[title]" with ""
    Then the button with translation "projects.update" should be disabled

  Scenario: Should be able to add a project even with empty description and tags
    Given PENDING: don't know how to select tags
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    And I click on the translation for "projects.edit" within ".projects-panel"
    And I fill in "brigade_project[description]" with "Vamos a mejorar las calles de Mexico!"
    And I fill in ".tags-input-container/input" with "scheme, Ruby, JAVA"
    Then the button with translation "projects.update" should be enabled