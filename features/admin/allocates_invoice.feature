Feature: Admin allocates portions of an invoice
  As an admin 
  I want to see the current allocations on an invoice and assign new allocations to staff 
  so everyone will know how much they will get paid

  Background: Logged in as admin
    Given I am logged in as an admin
    And there are multiple invoices, customers and people
    And 0 invoice_allocations exist

  Scenario: Allocate staff to an invoice
    When I go to the invoices page
    Then I should see multiple invoices

    When I view the first invoice
    Then I should see 0 invoice allocations

    When I fill in the new allocation form 
    Then I should be on the admin show invoice page
    And I should see 1 invoice allocation

