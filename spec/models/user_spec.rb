require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = User.plan
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should have a person" do
    u = Person.make.user
    u.person.should_not be_nil
  end

end
