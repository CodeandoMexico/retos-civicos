Feature: The search brigades page

<<<<<<< HEAD
  As a user
  I would like the ability to search for currently active brigades
  so that I can navigate to the brigade's page.

  Background: Brigades in database

    Given the following brigades with locations exist:
      | state      | city      | header_image_url                                                                |
      | Nuevo León | Monterrey | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png              |
      | Jalisco    | Tequila   | https://si.wsj.net/public/resources/images/OD-AZ228A_TEQUI_G_20131010155926.jpg |
      | Sinaloa    | Mazatlan  | http://latinflyer.com/wp-content/uploads/2013/06/MazatlanZona_DoradaLF.jpg      |

    And the following users are in brigade Tequila, Jalisco:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |

    And the following users are in brigade Mazatlan, Sinaloa:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |
      | test2@brigade_has_show_view.com | Potatoes are cool | 111111   |
      | test3@brigade_has_show_view.com | yessir            | 111111   |

    And I click on ".dropdown-toggle"
    And I click on the translation for "brigades.brigades"

  Scenario: Non-logged-in users can view brigades page.
    Then I should be on the brigades listing page

  Scenario: Logged-in users can view brigades page.
    When I click on ".dropdown-toggle"
    And I click on the translation for "brigades.brigades"
    Then I should be on the brigades listing page
    And I should see "Monterrey, Nuevo León"
    And I should see "Tequila, Jalisco"
    And I should see "Mazatlan, Sinaloa"
    And I should see translation for "brigades.no_members" within ".members"
    And I should see "1" within ".members"
    And I should see "3" within ".members"
    And I should see translation for "brigades.follow"
    And I should see image with src http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png
    And I should see image with src https://si.wsj.net/public/resources/images/OD-AZ228A_TEQUI_G_20131010155926.jpg
    And I should see image with src http://latinflyer.com/wp-content/uploads/2013/06/MazatlanZona_DoradaLF.jpg

  Scenario: See members in brigade when hover over members
    Given I fill in ".location-search" with "Mazatlan"
    When I hover over .members
    Then I should see "Bobble Head"
    Then I should see "Potatoes are cool"
    Then I should see "yessir"

  Scenario: Unsee members in brigade when unhover over members
    Given I fill in ".location-search" with "Mazatlan"
    When I hover over .members
    When I unhover over .members
    Then I should not see "Bobble Head"
    Then I should not see "Potatoes are cool"
    Then I should not see "yessir"

  Scenario: members modal should appear when members clicked
    Given I fill in ".location-search" with "Mazatlan"
    When I click on ".members"
    Then I should see "Bobble Head"
    Then I should see "Potatoes are cool"
    Then I should see "yessir"

  Scenario: Joining a brigade
    When I fill in ".location-search" with "Monterrey"
    And I click on the translation for "brigades.follow.follow"
    Then I should see translation for "brigades.follow.unfollow"

  Scenario: Unjoining a brigade
    Given I am logged in as a user with email "kyle@kyleboss.com" and name "Kyle Boss"
    And the following users are in brigade Monterrey, Nuevo León:
      | email             | name      | password |
      | kyle@kyleboss.com | Kyle Boss | "111111" |
    When I fill in ".location-search" with "Monterrey"
    And I click on the translation for "brigades.follow.unfollow"
    Then I should see translation for "brigades.follow.follow"

  Scenario: Search with valid location
    When I fill in ".location-search" with "Tequila"
    Then I should see "Tequila, Jalisco"
    And I should not see "Monterrey, Nuevo León"
    And I should not see "Mazatlan, Sinaloa"

  Scenario: Search invalid location
    When I fill in ".location-search" with "abc123def456"
    Then I should not see "Tequila, Jalisco"
    And I should not see "Monterrey, Nuevo León"
    And I should not see "Mazatlan, Sinaloa"
    And I should see translation for "brigades.no_brigades_match_search"

  Scenario: No bgit tag v1.4-lwrigades exist
    Given there are no brigades
    When I click on ".dropdown-toggle"
    And I click on the translation for "brigades.brigades"
    Then I should see translation for "brigades.no_brigades_exist"
