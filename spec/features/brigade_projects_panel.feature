Feature: Brigade Project Panel on Brigade page

  As a user
  I would like to quickly see all of the projects in a particular brigade
  So that I can easily take part in civic hacking.

  Background: Brigades in database

    Given the following users exist:
      | email                           | name        | password |
      | kyle@brigade_has_show_view.com  | Kyle        | 111111   |

    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   | github_url                        | twitter_url                        | facebook_url                    | slack_url                        |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png | https://github.com/CodeandoMexico | https://twitter.com/codeandomexico | https://www.facebook.com/events | https://codeandomexico.slack.com |

    Given the following users are in brigade Monterrey, Nuevo León:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |

  Scenario: visit brigade page that has projects
    Given I am logged in as a user
    Given the following projects exist in brigade Monterrey, Nuevo León:
      | title    | description                | users | tags                  |
      | Timbuktu | A very intriguing project. | 1, 2  | html, scheme, python  |
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see "Timbuktu"
    And I should see "A very intriguing project."
    And I should not see translation for "projects.no_projects_exist"
    And I should see translation for "brigades.show.project"

  Scenario: visit brigade page that has no projects
    Given I am logged in as a user
    Given no projects exist in brigade Monterrey, Nuevo León:
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see translation for "projects.no_projects_exist"
    And I should not see translation for "brigades.projects.contribute"