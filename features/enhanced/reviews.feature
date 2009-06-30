Feature: Events
  In order to know which restaurants are good
  As a user
  I can view reviews
  
  Scenario: Viewing reviews
    Given a review in Ottawa titled "Sir John A Pub" in 3 days
    And a review in Ottawa titled "Sushi Kan" 1 month ago
    When I view the map
    Then I see the review titled "Sir John A Pub"
    Then I do not see the review titled "Sushi Kan"
