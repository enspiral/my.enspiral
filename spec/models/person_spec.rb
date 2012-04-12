require 'spec_helper'

describe Person do
  describe "creating a person" do
    it "should be successful given valid attributes" do
      lambda {
        person = Person.make
        person.save!
      }.should change { Person.count }
    end

    it "should create an associated account" do
      p = Person.make
      p.account.should be_nil

      lambda {
        p.save
      }.should change {Account.count}

      p.reload
      p.account.should_not be_nil
    end

    it "should validate numericality of income fields" do
      @person = Person.create(:baseline_income => "blah", :ideal_income => "blah")
      @person.should have(1).error_on(:baseline_income)
      @person.should have(1).error_on(:ideal_income) 
    end
    
    it "should allow blank values of income fields" do
      @person = Person.create(:baseline_income => "", :ideal_income => "")
      @person.should_not have(1).error_on(:baseline_income)
      @person.should_not have(1).error_on(:ideal_income) 
    end
     
  end

  describe "an active person" do
    before(:each) do
      @p = Person.make
      @p.save!
      customer = Customer.make
      customer.save!
      @i = Invoice.make :customer => customer, :paid => false
      @i.save!
      @a1 = make_invoice_allocation_for(@i, @p, 0.25)
      @a2 = make_invoice_allocation_for(@i, @p, 0.50)
    end

    it 'has a default account, which is included in their list of accounts' do
      @account = Account.make!
      @p.account = @account
      @p.valid?
      @p.should have(1).errors_on(:account)
      @p.accounts << @account
      @p.valid?
      @p.should_not have(1).errors_on(:account)
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
  
  context "Active people" do
    before(:each) do
      @person = Person.make! :staff
    end
    it "should be active by default" do
      @person.active.should == true
      @person.user.active.should == true
    end
    it "should deactivate user" do
      @person.deactivate
      @person.active.should == false
      @person.user.active.should == false
    end
    it "should not deactivate if account balance not equal to 0" do
      @person = Person.make!
      @person.account.stub(:balance).and_return(10)
      lambda {
        @person.deactivate
      }.should raise_error
    end
    it "should have correct active scope" do
      inactive_person = Person.make! :staff, :active => false
      Person.active.should include(@person)
      Person.active.should_not include(inactive_person)
    end
  end
end
