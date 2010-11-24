require 'spec_helper'

describe Account do

  describe "creating an account" do
    before(:each) do
      @account = Account.make
    end

    it "should create a new instance given valid attributes" do
      @account.save.should be_true
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
