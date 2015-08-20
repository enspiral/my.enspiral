Feature: Reconcile expenditure
  As a company admin
  I want to be able to reconcile external expenditures
  So that the company accounts don't get out of sync

  Background:
    Given I am admin of a company with unreconciled expenditures
    And I am logged in

  Scenario: Admin views external accounts
    When I visit the external accounts page
    Then I should see a list of the external accounts associated with my company

  Scenario: Admin views unreconciled expenditures
    When I visit the external accounts page
    And I click the link to view the unreconciled expenditures for an external account
    Then I should see a list of unreconciled expenditures

  Scenario: Admin reconciles external expenditure
    When I visit the unreconciled expenditures page for an external account
    And I click "Reconcile"
    And I fill in and submit the form
    Then I should see that the expenditure has been reconciled
