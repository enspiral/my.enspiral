Feature: Admin adds an invoice
  As an admin
  I want to add an invoice to the system and allocate portions to each staff member
  So we can track amount billed by each person

  Background: Logged in as admin
    Given I am logged in as an admin
    And there are 0 invoices in the system
    And a customer named IOSS
    And a staff member named Sam Ootoowak
    And a staff member named Will Marshall

  Scenario: Add an invoice successfully
    When I create a new invoice worth $1000 
    And I allocate $700 to Sam
    And I allocate $300 to Will
    Then Sam should have $700 allocated
    And Will should have $300 allocated
    And I should have a new invoice worth $1000

  Scenario: Fill in new invoice form
    When I go to the new invoice page
    And I fill in "Amount" with "1000"
    And I select "IOSS" from "Customer"
    And I press "Save"
    Then I should have a new invoice worth $1000

    When I select "Sam Ootoowak" from "Staff"    
    And I fill in "Amount" with "700"
    And I press "Allocate"
    Then Sam should have $700 allocated

