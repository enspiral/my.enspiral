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
      @account.transactions.create(amount: 3, date: Date.today, description: 'test')
      @account.transactions.create(amount: 3, date: Date.today, description: 'test')
      @account.transactions.create(amount: 3, date: Date.today, description: 'test')
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
  end
end
