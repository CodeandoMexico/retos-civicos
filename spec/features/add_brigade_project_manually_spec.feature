Feature: Brigade organizer should be able to add a brigade project.

  As a brigade organizer
  I want to be able to add a project to the brigade manually
  So that I hackers can unite to complete a project without reliance on Github.

  Background: Brigades in database

    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

    Given the following users are in brigade Monterrey, Nuevo León:
      | email          | name  | password |
      | test1@test.com | Kyle  | 111111   |

  Scenario: Not able to add project when not logged in as organizer
    Given I am logged in as a follower of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should not see translation for "projects.add"

  Scenario: Able to see add project text when logged in as organizer
    Given I am logged in as the brigade organizer of Monterrey, Nuevo León brigade
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see translation for "projects.add"

  Scenario: Able to add project when logged in as organizer
    Given I visit the Monterrey, Nueveo León brigade page as its organizer
    When I click on the translation for "projects.create"
    And I fill in "project[title]" with "Semaforos"
    And I fill in "project[description]" with "Vamos a mejorar las calles de Mexico!"
    And I fill in "project[tags]" with "scheme, Ruby, JAVA"
    And I click on the translation for "projects.add"
    Then I should see translation for "projects.successfully_created"
    And the tags "scheme, ruby, java" should exist
    And there should only be 3 tags
    And the project "Semaforos" should exist in brigade "Monterrey, Nuevo León"
    And the project "Semaforos" in brigade "Monterrey, Nuevo León" should have the tags "scheme, ruby, java"
    And the project "Semaforos" in brigade "Monterrey, Nuevo León" should have the description "Vamos a mejorar las calles de Mexico!"

  Scenario: Should not be able to add a project with an empty title
    Given I visit the Monterrey, Nueveo León brigade page as its organizer
    When I fill in "project[description]" with "Vamos a mejorar las calles de Mexico!"
    And I fill in "project[tags]" with "scheme, Ruby, JAVA"
    Then the button with translation "projects.create" should be disabled

  Scenario: Should be able to add a project even with empty description and tags
    Given I visit the Monterrey, Nueveo León brigade page as its organizer
    When I fill in "project[title]" with "Semaforos"
    Then the button with translation "projects.create" should be enabled