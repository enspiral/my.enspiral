require 'spec_helper'

describe Account do
  describe 'model' do
    subject do
      @company = Company.create!(name: 'testco', default_contribution: 0.2)
      Account.make!(company: @company)
    end

    it {should have_many :people }
    it {should belong_to :company }
    it {should_not belong_to :person }
    it {should respond_to :public}
    it {should validate_presence_of :company}

    it 'has a scope of public' do
      public_account = Account.make!(:public => true)
      private_account = Account.make!(:public => false)
      Account.public.should include public_account
      Account.public.should_not include private_account
    end
  end

  describe "an existing account with multiple transactions" do
    before(:each) do
      @company = Company.create!(name: 'testco', default_contribution: 0.2)
      @account = Account.make!(company: @company)
      @account.transactions.create(amount: 3, date: 3.days.ago, description: 'test')
      @account.transactions.create(amount: 3, date: 2.days.ago, description: 'test')
      @account.transactions.create(amount: 3, date: Date.today, description: 'test')
      @account.calculate_balance
    end

    it "should calculate the balance correctly" do
      total = @account.transactions.inject(0) {|total, t| total += t.amount }
      @account.calculate_balance.should == total
    end

    it "should not not save if balance is !=0" do
      @account.closed = true
      @account.transactions.build(amount: 1, date: Date.today, description: 'donation')
      @account.valid?
      @account.should have(1).errors_on(:closed)
    end

    describe "balance_at" do
      it "should calculate balances at a given date" do
        @account.balance_at(2.days.ago).should == 6
        @account.balance_at(Date.today).should == 9
      end
      it "should set balance" do
        @account.balance.should == 9
        @account.balance_at(2.days.ago)
        @account.balance.should == 6
      end
      it "saving should not overwrite balance" do
        @account.balance_at(2.days.ago)
        @account.save
        @account.balance.should == 9
      end
    end

    describe "balances_at" do
      before do
        @a2 = Account.make!(company: @company)
        @a3 = Account.make!(company: @company, min_balance: -5)
        @a3.transactions.create!(amount: -3, date: 3.days.ago, description: 'test')
        @accounts = Account.balances_at @company, 2.days.ago
      end
      it "should not return any accounts with 0 balance" do
        @accounts.should_not include(@a2)
      end
      it "should return accounts which have a balance < 0" do
        @accounts.should include(@a3)
      end
      it "should return accounts which have a balance > 0" do
        @accounts.should include(@account)
      end
    end
  end

end
