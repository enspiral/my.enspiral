require 'spec_helper'

describe InvoiceAllocation do
  describe "creating an allocation" do
    before(:each) do
      @ia = InvoiceAllocation.new(InvoiceAllocation.plan)
    end

    it "should be successful" do
      @ia.save.should be_true 
    end

    it "should default to a commission of 20%" do
      @ia.commission.should == 0.2
    end

    it "should copy its commission from the person" do
      @ia.person.update_attribute(:base_commission, 0.1)
      @ia.save
      @ia.commission.should == 0.1
    end

    it "should not allow a negative commission" do
      @ia.commission = -0.1
      @ia.should_not be_valid
    end
  end

  describe "an undisbursed allocation" do
    before(:each) do
      @ia = make_invoice_allocation
      @ia.disbursed.should == false
    end

    it "should show the correct amount allocated" do
      @ia.amount_allocated.should < @ia.amount
    end

    it "should create a transaction when disbursed" do
      lambda {
        @ia.disburse
      }.should change { Transaction.count }.by (1)
    end
  end

  describe "a disbursed allocation" do
    before(:each) do
      @ia = make_invoice_allocation
      @ia.disburse
    end

    it "should not be able to be redisbursed" do
      lambda {
        @ia.disburse.should be_false
      }.should_not change {Transaction.count}
    end
  end

  describe "named scopes" do
    it "#pending should filter out disbursed allocations" do
      ia1 = InvoiceAllocation.make
      ia2 = InvoiceAllocation.make(:disbursed => true)
      @pending = InvoiceAllocation.pending
      @pending.should include(ia1)
      @pending.should_not include(ia2)
    end
  end
end
