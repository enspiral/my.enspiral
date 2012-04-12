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
  
  describe 'funds transfer' do
    before(:each) do
      @p1 = Person.make :staff
      @p1.save!
      @p2 = Person.make :staff
      @p2.save!
      t1 = Transaction.make :creator => @p1, :account => @p1.account, :amount => rand(5000)
      t1.save!
      t2 = Transaction.make :creator => @p2, :account => @p2.account, :amount => rand(5000)
      t2.save!
    end
    
    it 'should transfer funds from one person to another' do
      p1_balance = @p1.account.balance
      p2_balance = @p2.account.balance
      
      transfer_amount = rand(@p1.account.balance)
      @p1.transfer_funds_to(@p2, transfer_amount).should be_true
      
      @p1.reload
      @p2.reload
      
      @p1.account.balance.should eql(p1_balance - transfer_amount)
      @p2.account.balance.should eql(p2_balance + transfer_amount)
      
      p1_transaction = @p1.account.transactions.first
      p2_transaction = @p2.account.transactions.first
      
      p1_transaction.amount.to_i.should eql(transfer_amount * -1)
      p1_transaction.creator.should eql(@p1)
      p1_transaction.description.should eql("Fund transfer to #{@p2.name}")
      p1_transaction.date.should eql(Date.today)
      
      p2_transaction.amount.should eql(transfer_amount)
      p2_transaction.creator.should eql(@p1)
      p2_transaction.description.should eql("Fund transfer from #{@p1.name}")
      p2_transaction.date.should eql(Date.today)
    end
    
    it 'should not transfer negative amount' do
      @p1.transfer_funds_to(@p2, -1).should eql('Cannot transfer a negative amount')
    end
    
    it 'should not transfer amount greater than account balance' do
      transfer_amount = 100000
      @p1.account.balance.should be < transfer_amount
      @p1.transfer_funds_to(@p2, transfer_amount).should eql('Cannot transfer an amount greater than your account balance')
    end
    
    it 'should not transfer if account balance is less than zero' do
      person = Person.make :staff
      person.save!
      t = Transaction.make :creator => person, :account => person.account, :amount => -100
      t.save!
      person.transfer_funds_to(@p2, 100).should eql('You have a negative account balance. Cannot proceed with funds transfer')
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
