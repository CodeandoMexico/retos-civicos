Feature: User should be able to see his and others profile page

  As a user
  I can see my profile page
  I can see other users profile page

Scenario:
  Given I have just updated my information
  Then I should see the given profile page

Scenario:
  Given I have a link to another user profile
  Then I should see the other users profile page

Scenario:
  Give I don't want to show my public profile
  Then my profile should be hidden to other users
