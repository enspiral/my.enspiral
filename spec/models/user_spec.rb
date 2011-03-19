require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = { :role => 'staff',
                          :email => Faker::Internet.email,
                          :password => 'secret',
                          :password_confirmation => 'secret' }
  end

  it {should have_many(:badges)}

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should include contractors in staff?" do
    staff = User.make!(:role => 'staff')
    contractor = User.make!(:role => 'contractor')
    staff.should be_staff
    contractor.should be_staff
  end

end
