Feature: News Stories
  In order to receive up-to-date information
  As a user
  I can view news stories
  
  Scenario: Viewing a news story
    Given a news story in Ottawa, ON titled "Big news out of parliament"
    When I view the map
    Then I see the news story titled "Big news out of parliament"