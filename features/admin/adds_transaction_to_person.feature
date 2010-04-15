Feature: Admin adds a transaction to a person
  As an admin
  I want to add transactions to a user
  so we can track pays and expenses

  Background: Logged in as admin
    Given I am logged in as an admin
    And a person: "sam" exists

  Scenario: Add a transaction user account
    When I go to the admin show page for person: "sam"
    Then I should see 0 transactions

    When I follow "Add Transaction"
    And I fill in "date" with "2010-04-15"
    And I fill in "amount" with "-2500"
    And I fill in "description" with "Pay"
    And I press "Save"
    Then I should see 1 transaction
