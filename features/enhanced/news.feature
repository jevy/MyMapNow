Feature: News Stories
  In order to receive up-to-date information
  As a user
  I can view news stories
  
  Scenario: Viewing a news story
    Given a news story in Ottawa titled "Big news out of parliament"
    When I view the map
    Then I see the news story titled "Big news out of parliament"
    
  Scenario: A news story outside the current view
    Given a news story in Detroit titled "Auto Industry in Shambles"
    When I view the map
    Then I do not see the news story titled "Auto Industry in Shambles"