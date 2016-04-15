Feature: Brigade has show view

  As a user
  I would like to see relevant information for a specific brigade
  So that I can quickly become up-to-date with what it is doing and decide to join.

  Background: Brigades in database

    Given the following users exist:
      | email                           | name        | password |
      | kyle@brigade_has_show_view.com  | Kyle        | 111111   |
      | test0@brigade_has_show_view.com | Mr. Wiggles | 111111   |

    Given the following brigades exist:
      | location_id  | user_id | description                                         | calendar_url                                                                              | header_image_url                                                   |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png |

    Given the following users are in brigade Monterrey, Nuevo León:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |
      | test2@brigade_has_show_view.com | Potatoes are cool | 111111   |
      | test3@brigade_has_show_view.com | yessir            | 111111   |

  Scenario: visit brigade page
    Given I am logged in as a user with email "k@kboss.com" and name "Kyle Boss"
    When I visit the brigade page for Monterrey, Nuevo León
    Then I should see "Monterrey"
    And I should see "Bienvenido a la brigada de Monterrey! Come with us."
    And I should see translation for brigades.show.follow.follow
    And I should see translation for brigades.show.events.next_event
    And I should see translation for brigades.show.stats.statistics
    And I should see translation for brigades.show.member
    And I should see translation for brigades.show.members.organizer
    And .hero-image-container should have background http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png
    And I should see the text "Bobble Head" within ".members-panel-content"
    And I should see the text "Potatoes are cool" within ".members-panel-content"
    And I should not see the text "yessir" within ".members-panel-content"
    And I should not see the text "Mr. Wiggles" within ".members-panel-content"