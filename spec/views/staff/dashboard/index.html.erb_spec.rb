require 'spec_helper'

describe "/staff/dashboard/index" do
  before(:each) do
    account = mock_model(Account, :balance => 1000).as_null_object
    invoice_allocations = mock_model(InvoiceAllocation, :amount => 100).as_null_object
    transaction = mock_model(Transaction).as_null_object
    person = mock_model(Person, :pending_total => 5000)
    person.stub(:account).and_return account
    person.stub_chain(:account,:transactions_with_totals).and_return [[transaction,10]]
    person.stub_chain(:invoice_allocations, :pending).and_return [invoice_allocations]
    assign(:person, person)
  end

  describe "As a user" do
    before(:each) do
      view.stub(:admin_user?).and_return(false)
    end
    it "should show the correct balances" do
      render
      rendered.should contain('You have $1,000.00 available to spend')
      rendered.should contain('You have $5,000.00 invoiced')
    end
    it "should not contain a link to a new transaction" do
      render
      rendered.should_not have_selector('a', :content => 'Add Transaction')
    end
    it "should contain a link to transfer funds" do
      render
      rendered.should have_selector('a', :content => 'Transfer funds')
    end
  end
end
