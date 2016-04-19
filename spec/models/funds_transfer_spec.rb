require 'spec_helper'

describe FundsTransfer do
   let!(:company)       { Company.create(name: Faker::Company.name, default_contribution: 0.2) }

  it { should have_one :external_transaction }

  describe 'validations' do
    before(:each) do
      @ft = FundsTransfer.make
      @ft.source_account = Account.make!(company: company, min_balance: -3)
      @ft.destination_account = Account.make!(company: company)
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

    context 'if it would overdraw the account' do
      let(:new_ft) {
        FundsTransfer.create(author: @ft.author,
                             amount: 30,
                             source_account: @ft.source_account,
                             destination_account: @ft.destination_account,
                             description: 'should fail')
      }

      it 'is invalid if it would overdraw the account' do
        new_ft.should have(1).errors_on(:source_transaction)
      end

      it 'should let the user know how much the transfer would overdraw the account' do
        # puts new_ft.errors.messages.inspect
        fail("Expected someting containing /minimum balance of -$3/") unless new_ft.errors.messages[:source_account].select { |e| /minimum balance of -\$3/ =~ e }.any?
        fail unless new_ft.errors.messages[:source_account].select { |e| /exceed what they can draw by \$3/ =~ e }.any?
      end
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
      @source_account = Account.make!(company: company, min_balance: -3)
      @destination_account = Account.make!(company: company)
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
          @ftr.amount = 0.5
          @ftr.save!
        }.to change(Transaction,:count).by(0)
      end

      it 'updates transaction amounts' do
        @ftr.update_attribute(:amount, 2)
        @ftr.source_transaction.amount.should == -2
        @ftr.destination_transaction.amount.should == 2
      end

      it 'updates transaction dates' do
        @ftr.update_attribute(:date, 2.days.ago)
        @ftr.source_transaction.date.to_date.should == 2.days.ago.to_date
        @ftr.destination_transaction.date.to_date.should == 2.days.ago.to_date
      end

      it 'updates transaction accounts' do
        @ftr.source_account = Account.make!(company: company, min_balance: -3)
        @ftr.destination_account = Account.make!(company: company)
        @ftr.save
        @ftr.source_transaction.account.should == @ftr.source_account
        @ftr.destination_transaction.account.should == @ftr.destination_account
      end

      it 'updates balances of all transaction accounts' do
        old_source_account = @ftr.source_account
        old_destination_account = @ftr.destination_account
        @ftr.source_account = Account.make!(company: company, min_balance: -3)
        @ftr.destination_account = Account.make!(company: company)
        @ftr.save
        old_source_account.reload.balance.should == 0
        old_destination_account.reload.balance.should == 0
        @ftr.source_account.reload.balance.should == -1.5
        @ftr.destination_account.reload.balance.should == 1.5
      end
    end

  end

  describe "#destroy" do
    let!(:person)                    { Person.make! }
    let!(:source_account)            { Account.make!(company: company, min_balance: -3) }
    let!(:destination_account)       { Account.make!(company: company) }

    before do
      person.accounts << source_account
      @ftr = FundsTransfer.make(author: person,
                                amount: 2,
                                source_account: source_account,
                                destination_account: destination_account,
                                description: 'test transfer')
    end


    context ".build_transactions" do
      before do
        @ftr.save!
        @source_transaction = @ftr.source_transaction
        @destination_transaction = @ftr.destination_transaction
      end

      it 'should chain destroy source and destination transactions' do
        @ftr.destroy

        expect{@source_transaction.reload}.to raise_error
        expect{@destination_transaction.reload}.to raise_error
      end
    end
  end
end
