require 'spec_helper'

describe Account do
  it {should have_many(:people)}
  it {should have_many(:companies)}
  it {should_not belong_to(:person)}
  it {should respond_to :public}

  it 'has a scope of public' do
    public_account = Account.make!(:public => true)
    private_account = Account.make!(:public => false)
    Account.public.should include public_account
    Account.public.should_not include private_account
  end

  it "should have a valid blueprint" do
    Account.make.should be_valid  
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
