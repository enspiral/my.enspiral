require 'spec_helper'

describe FundsTransfer do
  before(:all) do
    @company = Company.create(name: Faker::Company.name, default_contribution: 0.2)
  end
  describe 'validations' do
    before(:each) do
      @ft = FundsTransfer.make
      @ft.source_account = Account.make!(company: @company, min_balance: -3)
      @ft.destination_account = Account.make!(company: @company)
      @ft.author = Person.make!
      @ft.description = "Description"
      @ft.amount = 3.0
      @ft.save!
    end

    it 'should validate_presence_of :author' do
      @ft.author = nil
      @ft.valid?
      @ft.should have(1).errors_on(:author)
    end

    it 'should validate_presence_of :source_account' do
      @ft.source_account = nil
      @ft.valid?
      @ft.should have(1).errors_on(:source_account)
    end

    it 'should validate_presence_of :destination_account' do
      @ft.destination_account = nil
      @ft.valid?
      @ft.should have(1).errors_on(:destination_account)
    end

    it 'validates amount is greater than 0' do
      @ft.amount = 0
      @ft.valid?
      @ft.should have(1).errors_on(:amount)

      @ft.amount = -1
      @ft.valid?
      @ft.should have(1).errors_on(:amount)
    end

    it 'validates source account is different from destination account' do
      @ft.source_account = @ft.destination_account
      @ft.valid?
      @ft.should have(1).errors_on(:destination_account)
    end

    it 'is invalid if it would overdraw the account', focus:true do
      @new_ft = FundsTransfer.create(author: @ft.author,
                                 amount: 1,
                                 source_account: @ft.source_account,
                                 destination_account: @ft.destination_account,
                                 description: 'should fail')
      @new_ft.should have(1).errors_on(:source_transaction)
    end

    it 'is invalid when the source and dest accounts have different companies ' do
      @ft.source_account.update_attribute(:min_balance, -5)
      @ft = FundsTransfer.create(author: @ft.author,
                                 amount: 1,
                                 source_account: @ft.source_account,
                                 destination_account: Account.make!,
                                 description: 'should fail')
      @ft.should have(1).errors_on(:destination_account)
    end
  end

  describe "#save" do
    before(:each) do
      @person = Person.make!
      @source_account = Account.make!(company: @company, min_balance: -3)
      @destination_account = Account.make!(company: @company)
      @person.accounts << @source_account
      @ftr = FundsTransfer.make(author: @person,
                               amount: 1.50,
                               source_account: @source_account,
                               destination_account: @destination_account,
                               description: 'test transfer')
    end


    context ".build_transactions" do
      it 'creates source and destination transactions' do
        expect {
          @ftr.save!
        }.to change(Transaction, :count).by(2)
        @ftr.source_transaction.should_not be_nil
        @ftr.destination_transaction.should_not be_nil
      end
    end

    context ".update_transactions" do
      before(:each) {@ftr.save!}
      it 'does not create transactions' do
        expect {
          @ftr.amount = 2
          @ftr.save!
        }.to change(Transaction,:count).by(0)
      end

      it 'updates transactions amount' do
        @ftr.update_attribute(:amount, 2)
        @ftr.source_transaction.amount.should == -2
        @ftr.destination_transaction.amount.should == 2
      end

      it 'updates transactions account' do
        @ftr.source_account = Account.make!(company: @company, min_balance: -3)
        @ftr.destination_account = Account.make!(company: @company)
        @ftr.save
        @ftr.source_transaction.account.should == @ftr.source_account
        @ftr.destination_transaction.account.should == @ftr.destination_account
      end

      it 'updates balances of all transaction accounts' do
        old_source_account = @ftr.source_account
        old_destination_account = @ftr.destination_account
        @ftr.source_account = Account.make!(company: @company, min_balance: -3)
        @ftr.destination_account = Account.make!(company: @company)
        @ftr.save
        old_source_account.reload.balance.should == 0
        old_destination_account.reload.balance.should == 0
        @ftr.source_account.reload.balance.should == -1.5
        @ftr.destination_account.reload.balance.should == 1.5
      end
    end

  end
end
