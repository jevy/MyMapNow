Feature: Approving an item
  In order to validate the worth of an item
  As a user
  I can approve an item
  
  Scenario: Approving an item
    Given a news story in Ottawa titled "Big news out of parliament"
    And "Big news out of parliament" is unapproved
    When I view the map    
    And I click on the news story titled "Big news out of parliament" in the list
    And I follow "Approve"
    Then "Big news out of parliament" has been approved