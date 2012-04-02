require 'spec_helper'

describe "/staff/dashboard/dashboard" do
  before(:each) do
    account = mock_model(Account, :balance => 1000).as_null_object
    invoice_allocations = mock_model(InvoiceAllocation, :amount => 100).as_null_object
    transaction = mock_model(Transaction).as_null_object
    
    person = Person.make!
    make_financials(person)

    view.stub(:current_person).and_return(person)
    
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
