require 'spec_helper'

describe "/admin/people/show" do
  before(:each) do
    @person = assigns[:person] = Person.make
  end

  it "should show the persons name" do
    render 'admin/people/show'
    response.should contain(@person.name)
  end

  it "should show transactions" do
    transactions = []
    10.times {|i| transactions << Transaction.make(:account => @person.account)}
    render 'admin/people/show'
    response.should have_selector(".transactions .transaction:nth-child(10)")
  end

end
