require 'spec_helper'

describe Account do
  it {should have_many(:owners)}
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

  describe "creating an account" do
    before(:each) do
      @account = Account.make!
    end

    it "should fail if account for project already exists" do
      @account = Account.make!(:project)
      @account2 = Account.make(:project, :project => @account.project)
      @account2.valid?
      @account2.should have(1).errors_on(:project_id)
      #@account2.should_not be_valid
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
