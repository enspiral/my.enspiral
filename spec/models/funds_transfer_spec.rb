require 'spec_helper'

describe FundsTransfer do
  describe 'normally' do
    before(:each) do
      @ft = FundsTransfer.make
      @ft.source_account = Account.make!
      @ft.destination_account = Account.make!
      @ft.source_account.balance = 3
      @ft.destination_account.balance = 3
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
  end

  it 'creates source and destination transactions on create' do
    person = Person.make!
    user = person.user
    destination_account = Account.make
    destination_account.balance = 3
    destination_account.save
    source_account = Account.make
    source_account.balance = 3
    source_account.save
    source_account.min_balance = 0
    destination_account.min_balance = 0
    person.accounts << source_account
    lambda{
    @ftr = FundsTransfer.make!(author: person,
                             amount: 1.50,
                             source_account: source_account,
                             destination_account: destination_account,
                             description: 'test transfer')
    }.should change(Transaction, :count).by(2)
    @ftr.source_transaction.should_not be_nil
    @ftr.destination_transaction.should_not be_nil
  end

  it 'is invalid if it would overdraw the account', focus:true do
    @person = Person.make!
    @src_account = Account.make!(min_balance: 0)
    @dest_account = Account.make!
    @ft = FundsTransfer.create(author: @person,
                               amount: 1,
                               source_account: @src_account,
                               destination_account: @dest_account,
                               description: 'should fail')
    @ft.should have(1).errors_on(:source_transaction)
  end

end
