Feature: Creating Items
  In order to increase the amount of data in the app
  As a user
  I can view submit items
  
  Scenario: Submitting a news story
    Given I am viewing the map
    When I click to submit a new item
    Then I see the new item form
    