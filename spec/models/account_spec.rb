require 'spec_helper'
require 'bigdecimal'

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

  describe "notifier when funds clear out" do
    before do 
      @company = Company.create!(name: 'Enspiral Services', default_contribution: 0.2)
      @account = @company.accounts.create!(name: 'reaksmey')
      @customer = @company.customers.create!(name: 'test')
      @invoice = @company.invoices.create!(amount: 40, customer: @customer, date: Date.today, due: Date.tomorrow)
      @user = User.create!(user_name: "reaksmey", email: "reaksmey@enspiral.com")
      @person = @company.people.create!(first_name: "reaksmey", last_name: "chea", email: "reaksmey@enspiral.com", user: @user)
      AccountsPerson.create!(account: @account, person: @person)
      @allocation = @invoice.allocations.create!(account: @account, amount: 40)
      @invoice.payments.create!(amount: 40, paid_on: Date.today,
                                invoice_allocation: @allocation, author: @person)
    end

    it "should find the company name Enspiral Services" do
      company = Company.find_by_name("Enspiral Services")
      company.should_not nil
    end

    it "should return income account under Enspiral Services" do
      sell_income = Company.find_by_name('Enspiral Services').income_account
      sell_income.should_not nil
    end

    it "should only send email to people who has funds transfer under company Enspiral Services" do
      sell_income = Company.find_by_name('Enspiral Services').income_account
      funds_transfers = FundsTransfer.where(:date => Date.today, :source_account_id => sell_income.id) 
      funds_transfers.should_not nil
    end

    it "should return funds cleared list" do
      results = Account.find_account_with_funds_cleared
      results.should_not nil
    end

    it "should return person with email" do
      results = Account.find_account_with_funds_cleared
      results[0][:person][:email].should == "reaksmey@enspiral.com"
    end
  end

  describe "get contribution report" do
    before do
      @company = Company.create!(name: 'Enspiral Services', default_contribution: 0.2)
      @account = @company.accounts.create!(name: 'reaksmey')
      @customer = @company.customers.create!(name: 'test')
      @support_account = @company.accounts.create!(name: 'Collective Funds')
      @income_account = @company.accounts.create!(name: 'Sales Income')
      @company.income_account = @income_account
      @company.support_account = @support_account
      @company.save!
      @invoice = @company.invoices.create!(amount: 40, customer: @customer, date: Date.today, due: Date.tomorrow)
      @user = User.create!(user_name: "reaksmey", email: "reaksmey@enspiral.com")
      @person = @company.people.create!(first_name: "reaksmey", last_name: "chea", email: "reaksmey@enspiral.com", user: @user)
      AccountsPerson.create!(account: @account, person: @person)
      @allocation = @invoice.allocations.create!(account: @account, amount: 40)
      @invoice.payments.create!(amount: 40, paid_on: Date.today,
                                invoice_allocation: @allocation, author: @person)
    end

    it "should have support account name collective funds" do
      @company.support_account.name.should == "Collective Funds"
    end

    it "should have income account name Sells Income" do
      @company.income_account.name.should == "Sales Income"
    end

    it "should make 2 funds transfer" do
      FundsTransfer.count.should == 2
    end

    it "should return montly contribution report" do
      from = Date.today.beginning_of_month
      to = Date.today.end_of_month
      report = Account.get_contribution_reports from,to,@company
      report.should == {"reaksmey"=>BigDecimal.new(8)}
    end

  end
end
