require 'spec_helper'

describe Invoice do

  describe "creating a new invoice" do
    before(:each) do
      @invoice = Invoice.new Invoice.plan
    end
    it "should be successful" do
      @invoice.save.should be_true
    end
  end

  describe "an unpaid invoice" do
    before(:each) do
      @invoice = Invoice.make(:paid => false)
    end

    describe "with 1 allocation" do
      before(:each) do
        @allocation = make_invoice_allocation_for(@invoice, Person.make)
      end

      it "should have many invoice_allocations" do
        @invoice.allocations.should include(@allocation)
      end

      it "should disburse funds upon payment" do
        @allocation.should_receive(:disburse).and_return true
        @invoice.stub(:allocations).and_return([@allocation])
        @invoice.mark_as_paid
        @invoice.paid.should be_true
      end
    end
  end
end
