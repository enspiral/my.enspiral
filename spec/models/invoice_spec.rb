require 'spec_helper'

describe Invoice do
  before(:each) do
    @valid_attributes = {
      :customer_id => 1,
      :amount => 9.99,
      :currency => "value for currency",
      :paid => false,
      :date => Date.today,
      :due => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Invoice.create!(@valid_attributes)
  end
end
