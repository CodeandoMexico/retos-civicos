Feature: Member of a brigade can contribute to projects.

  As a user,
  I would like to mark myself as contributing (or not contributing),
  so that I can remind myself and the world of which projects I am working on.

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



    Given I am logged in as the user with email "test2@test.com" and name "Boss"
    When I visit the brigade page for Monterrey, Nuevo León

  @javascript
  Scenario: User is not currently contributing to the project
    Then I should see the contribute-to-project button
    And I should not see my name in the project-contributors pop-over
    And I should not see my name in the project-contributors pop-up

  Scenario: Contribute button is red when user is contributing.
    When I click on the contribute-to-project button
    Then I should see the stop-contributing-to-project button
    And I should see my name in the project-contributors pop-over
    And I should see my name in the project-contributors pop-up