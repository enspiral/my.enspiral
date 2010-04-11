Feature: Admin adds an invoice
  As an admin
  I want to add an invoice to the system and allocate portions to each staff member
  So we can track amount billed by each person

  Background: Logged in as admin
    Given I am logged in as an admin

  Scenario: Add an invoice successfully
    Given ther are "0" invoices in the system
    And a staff member named "sam"
    And a staff member named "will"
    When I create a new invoice worth $"1000" 
    And I allocate $"700" to "sam"
    And I allocate $"300" to "will"
    Then "sam" should have $"700" allocated
    And "will" should have $"300" allocated
    

