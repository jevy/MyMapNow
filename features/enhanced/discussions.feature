Feature: Discussions
  In order to talk to other users
  As a user
  I can view discussions
  
  Scenario: Viewing a discussion
    Given a discussion in Ottawa titled "Traffic Sucks"
    And a discussion in Ottawa titled "Great Concert!"
    When I view the map
    Then I see the discussion titled "Traffic Sucks"
    
    When I click on the discussion titled "Traffic Sucks" in the list
    Then I see the discussion titled "Traffic Sucks" highlighted on the map
    And I see the discussion titled "Traffic Sucks" highlighted in the list
