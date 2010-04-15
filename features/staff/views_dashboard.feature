Feature: Staff views their dashboard
  As a staff member
  I want to see how much money I have and when I will get more
  So I can budget for the future

  Background: Logged in staff member
    Given I am logged in as staff
    And my account balance is $0
    And an unpaid invoice numbered 1001 worth $5000
    And I have been allocated $2500 of invoice 1001
    And I receive 80% of everything I invoice

  Scenario: Invoice is not yet paid
    When I go to my dashboard
    Then I should see "You have $0.00 available in your account"
    And I should see "You have $2,000.00 awaiting payment"

  Scenario: Allocated funds are disbursed
    When invoice numbered 1001 is marked as paid
    And I go to my dashboard
    Then I should see "You have $2,000.00 available in your account" 
    And I should see "You have $0.00 awaiting payment"
    And my account balance should be $2000



