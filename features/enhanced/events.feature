Feature: Events
  In order to know what's going on in the community
  As a user
  I can view events
  
  Scenario: Viewing events
    Given an event in Ottawa titled "Fringe Festival" in 3 days
    And an event in Ottawa titled "Bluesfest" 1 month ago
    When I view the map
    Then I see the event titled "Fringe Festival"
    Then I do not see the event titled "Bluesfest"
    