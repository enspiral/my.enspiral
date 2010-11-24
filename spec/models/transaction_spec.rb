require 'spec_helper'

describe Transaction do

  describe "creating a transaction" do
    before(:each) do
      account = Account.make
      account.save
      @transaction = Transaction.make :account => account
    end

    it "should create a new instance given valid attributes" do
      @transaction.save.should be_true
    end

    it "should change the account balance after create" do
      should_update_account_balance { @transaction.save }
    end

  end

  describe "an existing transaction" do
    before(:each) do
      @transaction = Transaction.make
    end

    it "should change the account balance after being deleted" do
      should_update_account_balance { @transaction.destroy }
    end
  end
end

def should_update_account_balance &block
  @transaction.account.should_receive(:calculate_balance).and_return true
  yield
end
