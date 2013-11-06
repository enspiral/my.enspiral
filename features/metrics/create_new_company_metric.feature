Feature: Company admin records metrics info for their company
  As a company admin
  So that I can keep everyone up-to-date with company performance
  I want to be able to record my company metrics (revenue, active users, etc.)

  Scenario: Company admin adds new metrics info
    Given I am a company admin
    And I am logged in
    When I visit the company metrics page
    And I click on "Add metric info"
    And I fill in and submit the new metric form
    Then I should be redirected to the company metrics page
    And I should see the new metric

  Scenario: Company admin edits existing metric info
    Given I am a company admin
    And I am logged in
    And the company has an existing metric
    When I visit the company metrics page
    And I choose to edit the existing metric
    And I edit and submit the existing metric form
    Then I should be redirected to the company metrics page
    And I should see the edited metric

  Scenario: Company non-admin views company metrics page
    Given I am not a company admin
    And I am logged in
    When I visit the company metrics page
    Then I should not see "Add metric info"

  Scenario: Company non-admin tries to view add new metric form
    Given I am not a company admin
    And I am logged in
    When I visit the company create new metric page
    Then I should be redirected to the company metrics page
