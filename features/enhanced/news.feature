Feature: News Stories
  In order to receive up-to-date information
  As a user
  I can view news stories
  
  Scenario: Viewing a news story
    Given a news story in Ottawa titled "Big news out of parliament"
    And a news story in Ottawa titled "Prime Minister speaks out"
    When I view the map
    Then I see the news story titled "Big news out of parliament"
    
    When I click on the news story titled "Big news out of parliament" in the list
    Then I see the news story titled "Big news out of parliament" highlighted on the map
    And I see the news story titled "Big news out of parliament" highlighted in the list
    
    When I click on the news story titled "Prime Minister speaks out" on the map
    Then I see the news story titled "Prime Minister speaks out" highlighted on the map
    And I see the news story titled "Prime Minister speaks out" highlighted in the list
    And I see the news story titled "Big news out of parliament" is not highlighted
    
  Scenario: A news story outside the current view
    Given a news story in Detroit titled "Auto Industry in Shambles"
    When I view the map
    Then I do not see the news story titled "Auto Industry in Shambles"