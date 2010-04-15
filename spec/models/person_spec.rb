require 'spec_helper'

describe Person do

  describe "creating a person" do
    it "should be successful given valid attributes" do
      lambda {
        Person.create! Person.plan
      }.should change { Person.count }
    end

    it "should create an associated account" do
      p = Person.new Person.plan
      p.account.should be_nil

      lambda {
        p.save
      }.should change {Account.count}

      p.reload
      p.account.should_not be_nil
    end
  end

  describe "an active person"
    before(:each) do
      @p = Person.make
      @i = Invoice.make(:paid => false)
      @a1 = make_invoice_allocation_for(@i, @p, 0.25)
      @a2 = make_invoice_allocation_for(@i, @p, 0.50)
    end

    it "should have invoice allocations" do
      @p.invoice_allocations.size.should == 2
    end

    it "should have a pending total with the commission taken out" do
      @p.allocated_total.should == @i.amount * 0.75 * (1 - @p.base_commission)
    end

    it "should ignore disbursed allocations from pending_total" do
      @a1.update_attribute(:disbursed, true)
      @p.pending_total.should == @i.amount * 0.50 * (1 - @p.base_commission)
    end
end
