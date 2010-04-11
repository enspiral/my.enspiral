require 'spec_helper'

describe InvoiceAllocation do
  before(:each) do
    @valid_attributes = {
      :person_id => 1,
      :invoice_id => 1,
      :amount => 9.99,
      :currency => "value for currency",
      :disbursed => false
    }
  end

  it "should create a new instance given valid attributes" do
    InvoiceAllocation.create!(@valid_attributes)
  end
end
