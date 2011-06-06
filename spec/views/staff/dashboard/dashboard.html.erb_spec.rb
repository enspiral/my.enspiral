require 'spec_helper'

describe "/staff/dashboard/dashboard" do
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
    
    it "should not contain a link to a new transaction" do
      render
      rendered.should_not have_selector('a', :content => 'Add Transaction')
    end
  end
end
