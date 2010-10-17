require 'spec_helper'

describe "/admin/people/show" do
  before(:each) do
    @person = Person.make
    @person.save!
    assigns[:person] = @person
  end

  it "should show the persons name" do
    render
    rendered.should contain(@person.name)
  end

  it "should show transactions" do
    10.times {|i| Transaction.make(:account => @person.account).save! }
    render
    rendered.should have_selector(".transactions .transaction:nth-child(10)")
  end
end
