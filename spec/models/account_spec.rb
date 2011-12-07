require 'spec_helper'

describe Account do

  it "should have a valid blueprint" do
    Account.make.should be_valid  
  end

  describe "creating an account" do
    before(:each) do
      @account = Account.make!
    end

    it "should fail if account for person already exists" do
      @account2 = Account.make(:person => @account.person)
      @account2.should_not be_valid
    end

    it "should fail if account for project already exists" do
      @account = Account.make!(:project)
      @account2 = Account.make(:project, :project => @account.project)
      @account2.should_not be_valid
    end
  end

  describe "an existing account with multiple transactions" do
    before(:each) do
      @account = Account.make
      @transactions = []
      10.times do
        @transactions << Transaction.make(:account => @account)
      end
      @account.transactions = @transactions
    end

    it "should calculate the balance correctly" do
      @account.update_attribute(:balance, 0)
      total = @transactions.inject(0) {|total, t| total += t.amount }
      @account.calculate_balance.should == total
      @account.balance.should == total
    end

  end
end
