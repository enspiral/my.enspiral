require 'spec_helper'

describe "/staff/dashboard/index" do
  before(:each) do
    account = mock_model(Account, :balance => 1000)
    person = mock_model(Person, :pending_total => 5000)
    person.stub(:account).and_return account
    @controller.stub(:current_person => person)
    render 'staff/dashboard/index'
  end

  it "should show the correct account balance" do
    response.should contain('You have $1,000.00 available')
  end

  it "should show the corect pending balance" do
    response.should contain('You have $5,000.00 awaiting payment')
  end
end
