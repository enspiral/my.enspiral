require 'spec_helper'

describe FundsTransfer do
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
    #amount and invalid transaction
    @ft.should have(2).errors_on(:amount)

    @ft.amount = -1
    @ft.valid?
    @ft.should have(2).errors_on(:amount)
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

  it 'validates that created transactions are not created if they will bring the account to below its min_balance' do
    #hbnnnnnnnnnng
    @ft.amount = -3
    @ft.source_account.balance = 0
    @ft.source_account.min_balance = 0
    @ft.destination_account.balance = 0
    @ft.destination_account.min_balance = 0
    @ft.valid?
    puts @ft.errors.inspect
    @ft.should have(1).errors_on(:amount)
    @ft.source_account.balance = 4
    @ft.source_account.min_balance = 0
    @ft.valid?
    @ft.should have(0).errors_on(:amount)
  end

  #it 'validates author is owner of source_account on create' do
    #person = Person.make!
    #user = person.user
    #source_account = Account.make!
    #destination_account = Account.make!
    #ft = FundsTransfer.make(author: person,
                              #amount: 1.50,
                              #source_account: source_account,
                              #destination_account: destination_account)
    #ft.valid?
    #ft.should have(1).errors_on(:source_account)
    #ft.errors_on(:source_account).should(
      #include "author must be source account owner")
  #end
end
