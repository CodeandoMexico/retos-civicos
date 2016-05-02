Feature: Hide Unused Social Network Buttons

  As a Brigade
  I would like to hide the social network buttons for social networks that I do not have a link to
  So that I do not provide my members with false information or false hope

    Scenario: Brigade has no network links, all buttons hidden
      Given the following brigades exist:
      | location_id  | user_id | description                                         |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. |
      When I am logged in as a user
      When I visit the brigade page for Monterrey, Nuevo León
      Then I should see no social network buttons
    
    Scenario: Brigade only has a github link, only github button should be visible
      Given the following brigades exist:
      | location_id  | user_id | description                                         | github_url                                           |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://github.com/CodeandoMexico/codeandomexico.org | 
      When I am logged in as a user
      When I visit the brigade page for Monterrey, Nuevo León
      Then I should see a button for Github
      And  I should not see a button for Facebook
      And  I should not see a button for Slack
      And  I should not see a button for Twitter
    
    Scenario: Brigade has a Twitter, Facebook, and Slack link, only Github button should be hidden
      Given the following brigades exist:
      | location_id  | user_id | description                                         | twitter_url                        | facebook_url                    | slack_url                        |
      | 1            | 1       | Bienvenido a la brigada de Monterrey! Come with us. | https://twitter.com/codeandomexico | https://www.facebook.com/events | https://codeandomexico.slack.com |

      When I am logged in as a user
      When I visit the brigade page for Monterrey, Nuevo León
      Then I should not see a button for Github
      And  I should see a button for Facebook
      And  I should see a button for Slack
      And  I should see a button for Twitter