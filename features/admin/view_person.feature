Feature: Admin views a person
  As an admin
  I want to view a staff member
  so I will know be able to monitor their performance

  Background: Logged in as admin
    Given I am logged in as an admin
    And an account: "sams" exists
    And a person: "sam" exists with account: account "sams", first_name: "Sam", last_name: "Ootoowak"
    And 10 transactions exist with account: account "sams" 

  Scenario: View staff profile
    When I go to the admin show page for person: "sam"
    Then I should see "Sam Ootoowak"
    And I should see 10 transactions

