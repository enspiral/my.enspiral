require 'spec_helper'

describe FundsTransfersController do

  let!(:company)              { Company.make }
  let!(:person)               { Person.make!(:staff) }
  let!(:personal_account)     { Account.make!(company: company) }
  let!(:company_account)      { Account.make!(company: company) }
  let!(:destination_account)  { Account.make!(company: company) }

  describe 'creatig a new transaction' do
    before :each do
      personal_account.transactions.create!(amount: 50,
                                             description: 'pocket money',
                                             date: Date.current)
      CompanyMembership.make!(company:company, person:person, admin: true)
      person.accounts << personal_account

      company_account.transactions.create!(amount: 50,
                                             description: 'pocket money',
                                             date: Date.current)
      sign_in person.user
    end

    it 'shows new funds transfer form' do
      get :new, company_id: company.id
      response.should be_success
    end

    it 'creates a funds transfer for a company account' do
      post :create, :company_id => company.id,
        :funds_transfer =>
        { :source_account_id => company_account.id,
          :destination_account_id => destination_account.id,
          :description => 'test transfer',
          :amount => '12.50'}
      @funds_transfer = assigns(:funds_transfer)
      @funds_transfer.should be_valid
      @funds_transfer.author.should == person
      response.should be_redirect
    end

    it 'requires the current user is source account owner' do
      regular_person = Person.make!(:staff)
      CompanyMembership.make!(company:company, person:regular_person, admin: false)
      sign_in regular_person.user

      #huhuuh lets steal someones money
      post :create, company_id: company.id,
        :funds_transfer =>
        { :source_account_id => destination_account.id,
          :destination_account_id => personal_account.id,
          :description => 'test transfer',
          :amount => '12.50'}

      # foiled again
      @funds_transfer = assigns(:funds_transfer)
      @funds_transfer.should_not be_persisted
      flash[:alert].should match /don't have enough privileges/
    end
  end

  describe '#undo' do

    let!(:amount)                               { 100 }
    let!(:destination_original_balance)         { destination_account.balance}
    let!(:source_original_balance)              { destination_account.balance}
    let!(:other_person)                         { Person.make!(:staff) }
    let!(:cant_use_before_argh)                 { personal_account.update_attribute(:min_balance, -(amount)) }
    let!(:description)                          { "for services rendered <3" }
    let!(:source_transaction)                   { Transaction.new(account: personal_account, amount:  -(amount), description: description,
                                                          creator: other_person, date: 2.days.ago) }
    let!(:destination_transaction)              { Transaction.new(account: destination_account, amount:  amount, description: description,
                                                          creator: other_person, date: 2.days.ago) }

    let!(:funds_transfer)                       { FundsTransfer.create!(author: other_person, amount: amount, source_account: personal_account, destination_account: destination_account,
                                                     source_transaction: source_transaction, destination_transaction: destination_transaction, date: 2.days.ago,
                                                      description: description) }

    before do
      @destination_acct_post_transfer_balance = destination_account.balance
      @source_acct_post_transfer_balance = personal_account.balance
    end

    context 'if the user is not an admin' do

      before do
        sign_in person.user
      end

      context 'if it is within 10 minutes' do

        it 'should fail' do
          get :undo, company_id: company.id, id: funds_transfer.id, format: :json

          expect(response.status).to eq 403
          expect(response.body).to match /not an administrator/
          no_change_to_transfer_or_balances
        end
      end

      context 'if more than 10 minutes has elapsed' do

        before do
          update_transfer_to_20_minutes_ago
        end

        it 'should fail!' do
          get :undo, company_id: company.id, id: funds_transfer.id, format: :json

          expect(response.status).to eq 403
          expect(response.body).to match /not an administrator/
          no_change_to_transfer_or_balances
        end
      end

      context 'if there is enough funds in the destination account to reverse the transaction' do

        before do
          restrict_destination_account_min_balance
        end

        it 'should still fail!' do
          get :undo, company_id: company.id, id: funds_transfer.id, format: :json

          expect(response.status).to eq 403
          expect(response.body).to match /not an administrator/
          no_change_to_transfer_or_balances
        end

        context 'if it is within 10 minutes' do

          context 'if done by a different user' do
            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not an administrator/
              no_change_to_transfer_or_balances
            end
          end

          context 'if done by that user' do
            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not an administrator/
              no_change_to_transfer_or_balances

            end
          end
        end

        context 'if more than 10 minutes has elapsed' do

          before do
            update_transfer_to_20_minutes_ago
          end

          it 'should fail!' do
            get :undo, company_id: company.id, id: funds_transfer.id, format: :json

            expect(response.status).to eq 403
            expect(response.body).to match /not an administrator/
            no_change_to_transfer_or_balances
          end
        end
      end
    end

    context 'if the user is an admin' do

      before do
        make_person_system_admin
        @request.env["devise.mapping"] = Devise.mappings[:user]

        sign_in :user, person.user
      end

      context 'if the transaction was originally done by that user' do

        before do
          set_transaction_author_to_person
        end

        context 'if it is within 10 minutes' do

          context 'if there is enough funds in the destination account to reverse the transaction' do

            # FINALLY! xD
            it 'should succeed' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 200
            end
          end

          context 'if there is not enough funds in the original destination account to reverse the transaction' do

            before do
              restrict_destination_account_min_balance
            end

            it 'should fail!' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 409
              expect(response_body).to match /it would overdraw/
              no_change_to_transfer_or_balances
            end
          end
        end

        context 'if more than 10 minutes has elapsed' do

          before do
            update_transfer_to_20_minutes_ago
          end

          context 'if there is enough funds in the destination account to reverse the transaction' do

            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 423
              expect(response_body).to match /minutes have elapsed/
              no_change_to_transfer_or_balances
            end
          end

          context 'if there is not enough funds in the original destination account to reverse the transaction' do

            before do
              restrict_destination_account_min_balance
            end

            it 'should fail!' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 423
              expect(response_body).to match /minutes have elapsed/
              no_change_to_transfer_or_balances
            end
          end
        end
      end

      context 'if the transaction was originally done by a different user' do

        context 'if there is enough funds in the destination account to reverse the transaction' do

          context 'if it is within 10 minutes' do

            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not performed by you/
              no_change_to_transfer_or_balances
            end

          end

          context 'if more than 10 minutes has elapsed' do

            before do
              update_transfer_to_20_minutes_ago
            end

            it 'should fail!' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not performed by you/
              no_change_to_transfer_or_balances
            end

          end

        end

        context 'if there is not enough funds' do

          before do
            restrict_destination_account_min_balance
          end

          it 'should fail!' do
            get :undo, company_id: company.id, id: funds_transfer.id, format: :json

            expect(response.status).to eq 403
            expect(response.body).to match /not performed by you/
            no_change_to_transfer_or_balances
          end

          context 'if it is within 10 minutes' do

            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not performed by you/
              no_change_to_transfer_or_balances
            end

          end

          context 'if more than 10 minutes has elapsed' do

            before do
              update_transfer_to_20_minutes_ago
            end

            it 'should fail' do
              get :undo, company_id: company.id, id: funds_transfer.id, format: :json

              expect(response.status).to eq 403
              expect(response.body).to match /not performed by you/
              no_change_to_transfer_or_balances
            end

          end

        end
      end

    end

    def no_change_to_transfer_or_balances
      expect{funds_transfer.reload}.to_not raise_error
      expect(destination_account.balance).to eq @destination_acct_post_transfer_balance
      expect(personal_account.balance).to eq @source_acct_post_transfer_balance
    end

    def funds_transfer_destroyed
      expect{funds_transfer.reload}.to raise_error
      expect(personal_account.balance).to eq source_original_balance
      expect(destination_account.balance).to eq destination_original_balance
    end

    def restrict_destination_account_min_balance
      destination_account.update_attribute(:min_balance, destination_account.balance)
    end

    def update_transfer_to_20_minutes_ago
      [funds_transfer, funds_transfer.source_transaction, funds_transfer.destination_transaction].each do |thing|
        thing.update_column(:created_at, 20.minutes.ago)
        thing.reload
      end
    end

    def set_transaction_author_to_person
      funds_transfer.update_column :author_id, person.id
    end

    def make_person_system_admin
      person.user.update_attribute(:role, "admin")
    end

    def make_person_company_admin
      # some implementation here
    end

    def response_body
      # JSON.parse(response.body, quirks_mode: true)
      response.body
    end

  end

end
