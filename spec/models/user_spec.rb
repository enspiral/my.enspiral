require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = { :role => 'staff',
                          :email => Faker::Internet.email,
                          :password => 'secret',
                          :password_confirmation => 'secret' }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

end
