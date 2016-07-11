Feature: The search brigades page

  As a user
  I would like the ability to search for currently active brigades
  so that I can navigate to the brigade's page.

  Background: Brigades in database

    Given the following brigades with locations exist:
      | zip_code | state      | city      | header_image_url                                                                |
      | 64000    | Nuevo León | Monterrey | http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png              |
      | 48400    | Jalisco    | Tequila   | https://si.wsj.net/public/resources/images/OD-AZ228A_TEQUI_G_20131010155926.jpg |
      | 82000    | Sinaloa    | Mazatlan  | http://latinflyer.com/wp-content/uploads/2013/06/MazatlanZona_DoradaLF.jpg      |

    And the following users are in brigade Tequila, Jalisco:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |

    And the following users are in brigade Mazatlan, Sinaloa:
      | email                           | name              | password |
      | test1@brigade_has_show_view.com | Bobble Head       | 111111   |
      | test2@brigade_has_show_view.com | Potatoes are cool | 111111   |
      | test3@brigade_has_show_view.com | yessir            | 111111   |

    When I visit the home page
    And I click on "Participa"
#    And I click on the translation for "brigades.brigades"

  Scenario: Non-logged-in users cannot view brigades page.
    Given PENDING: "Brigades has been temporarily removed"
    Then I should be on the login page

  Scenario: Logged-in users can view brigades page.
    Given PENDING: "Brigades has been temporarily removed"
    Given I am logged in as a user
    When I click on "Participa"
    And I click on the translation for "brigades.brigades"
    Then I should be on the brigades listing page
    And I should see "Monterrey, Nuevo León"
    And I should see "Tequila, Jalisco"
    And I should see "Mazatlan, Sinaloa"
    And I should see "1 miembro"
    And I should see "2 miembros"
    And I should see "4 miembros"

  Scenario: No brigades exist
    Given PENDING: "Brigades has been temporarily removed"
    Given I am logged in as a user
    Given there are no brigades
    When I click on "Participa"
    And I click on the translation for "brigades.brigades"
    Then I should see translation for "brigades.index.no_brigades_exist"
