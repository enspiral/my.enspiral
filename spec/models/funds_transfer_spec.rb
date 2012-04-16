require 'spec_helper'

describe FundsTransfer do
  it {should validate_presence_of :author}
  it {should validate_presence_of :source_account}
  it {should validate_presence_of :destination_account}

  it 'validates amount is greater than 0' do
    subject.amount = 0
    subject.valid?
    subject.should have(1).errors_on(:amount)

    subject.amount = -1
    subject.valid?
    subject.should have(1).errors_on(:amount)
  end

  it 'creates source and destination transactions on create' do
    person = Person.make!
    user = person.user
    source_account = Account.make!
    destination_account = Account.make!
    person.accounts << source_account
    lambda{
    @ft = FundsTransfer.make!(author: person,
                             amount: 1.50,
                             source_account: source_account,
                             destination_account: destination_account,
                             description: 'test transfer')
    }.should change(Transaction, :count).by(2)
    @ft.source_transaction.should_not be_nil
    @ft.destination_transaction.should_not be_nil
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
