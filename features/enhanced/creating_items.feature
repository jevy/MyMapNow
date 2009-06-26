Feature: Creating Items
  In order to increase the amount of data in the app
  As a user
  I can view submit items
  
  Scenario: Submitting a news story
    Given I am viewing the map
    When I click to submit a new item
    Then I see the new item form
    
    When I select "Event" from "Kind"
    And I fill in "Title" with "Pairing at Lemonjellos"
    And I fill in "Description" with "Something"
    And I fill in "Address" with "Ottawa"
    And I set "Begin At" to 3 days from now
    And I set "End At" to 5 days from now
    And I save the item
    
    Then I see the event titled "Pairing at Lemonjellos"
    