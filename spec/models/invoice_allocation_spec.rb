require 'spec_helper'

describe InvoiceAllocation do
  describe "creating an allocation" do
    before(:each) do
      person = Person.make
      person.save!
      customer = Customer.make
      customer.save!
      invoice = Invoice.make :customer => customer
      invoice.save!
      @ia = InvoiceAllocation.make :person => person, :invoice => invoice
      @ia
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

    it "should not be able to over allocate an invoice" do
      @ia.amount = @ia.invoice.amount + 1
      @ia.should_not be_valid
    end

  end

  describe "an undisbursed allocation" do
    before(:each) do
      person = Person.make
      person.save!
      customer = Customer.make
      customer.save!
      invoice = Invoice.make :customer => customer
      @ia = make_invoice_allocation_for invoice, person
      @ia.disbursed.should == false
    end

    it "should show the correct amount allocated" do
      @ia.amount_allocated.should < @ia.amount
    end

    it "should create a transaction when disbursed" do
      lambda {
        @ia.disburse
      }.should change { Transaction.count }.by(1)
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
      person = Person.make
      person.save!
      customer = Customer.make
      customer.save!
      invoice = Invoice.make :customer => customer
      invoice.save!
      ia1 = InvoiceAllocation.make :person => person, :invoice => invoice
      ia1.save!
      ia2 = InvoiceAllocation.make :person => person, :invoice => invoice, :disbursed => nil
      ia2.save!
      ia3 = InvoiceAllocation.make :person => person, :invoice => invoice, :disbursed => true
      ia3.save!
      @pending = InvoiceAllocation.pending
      @pending.should include(ia1)
      @pending.should include(ia2)
      @pending.should_not include(ia3)
    end
  end
end
