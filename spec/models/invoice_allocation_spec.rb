require 'spec_helper'

describe InvoiceAllocation do
  describe "creating an allocation" do
    before(:each) do
      @ia = InvoiceAllocation.make
    end

    it "should not allow a negative commission" do
      @ia.commission = -0.1
      @ia.should_not be_valid
    end

    it "should not be able to over allocate an invoice" do
      @ia.amount = @ia.invoice.amount + 1
      @ia.should_not be_valid
    end

  end

  describe "an undisbursed allocation" do
    before(:each) do
      @ia = make_invoice_allocation_for
      @ia.disbursed.should == false
      @author = Person.make!
    end

    it "should show the correct amount allocated" do
      @ia.amount_allocated.should < @ia.amount
    end

    it "should create 2 FundsTransfers when disbursed" do
      lambda {
        @ia.disburse!(@author)
      }.should change { FundsTransfer.count }.by(2)
    end
  end

  describe "a disbursed allocation" do
    before(:each) do
      @ia = make_invoice_allocation
      @author = Person.make!
      @ia.disburse(@author)
    end

    it "should not be able to be redisbursed" do
      lambda {
        @ia.disburse!(@author)
      }.should_not change {Transaction.count}
    end

    it "should set disbursed attribute" do
      @ia.disbursed?.should be_true
    end
  end
end
