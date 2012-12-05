require 'spec_helper'

module Enspiral
  module MoneyTree
    describe Invoice do
      before(:each) do
        @invoice = Invoice.make!(amount: 10)
        @invoice.company.income_account.min_balance = -10
        @invoice.company.income_account.save!
        @account = @invoice.company.accounts.create!
        @person = Enspiral::CompanyNet::Person.make!
      end

      context 'a new invoice' do
        it 'is not paid' do
          @invoice.paid?.should be_false
        end

        it 'is not allocated' do
          @invoice.allocated_in_full?.should be_false
        end

      end

      context 'payments' do
        before do
          @allocation = @invoice.allocations.create!(account: @account, amount: 10)
        end

        it 'is paid when payments meet amount' do
          @invoice.payments.create!(amount: 10, paid_on: Date.today,
                                    invoice_allocation: @allocation, author: @person)
          @invoice.paid?.should be_true
        end

        it 'is not paid when payments less than amount' do
          @invoice.payments.create!(amount: 9, paid_on: Date.today,
                                   invoice_allocation: @allocation, author: @person)
          @invoice.paid?.should be_false
        end
      end

      describe 'allocations' do
        it 'is allocated when allocations meet amount' do
          @invoice.allocations.create!(account: @account, amount: 10, contribution: 0)
          @invoice.allocated_in_full?.should be_true
        end

        it 'is not allocated when allocations less than amount' do
          @invoice.allocations.create!(account: @account, amount: 9, contribution: 0)
          @invoice.allocated_in_full?.should be_false
        end

        it 'should not be valid if over allocated' do
          @invoice.allocations.create(account: @account, amount: 11, contribution: 0)
          @invoice.valid?
          @invoice.should have(1).errors_on(:amount_allocated)
        end
      end

      describe "an unpaid invoice" do
        describe "with 1 allocation" do
          before(:each) do
            @company = Enspiral::CompanyNet::Company.create!(name: 'testco', default_contribution: 0.2)
            @customer = Enspiral::CompanyNet::Customer.make!(company: @company)
            @invoice = Invoice.make!(company: @company, customer: @customer)
            @account = Account.make!(company: @company)
            @allocation = @invoice.allocations.create(account: @account, amount: @invoice.amount)
          end

          it "should destroy the allocations when destroyed" do
            @invoice.destroy
            lambda { @allocation.reload }.should raise_error(ActiveRecord::RecordNotFound)
          end

          it "should not allow a paid invoice to be destroyed" do
            @invoice.payments.create!(amount: 10, paid_on: Date.today,
                                      invoice_allocation: @allocation, author: @person)
            lambda { @invoice.destroy }.should raise_error
          end

          context 'being closed' do
            before {@invoice.close! @person}
            subject {@invoice}
            its(:paid_in_full?) {should be_true}
          end
        end
      end

      describe "unique xero_references" do
        it "is not required if blank" do
          lambda {
            @i = Invoice.make!
            Invoice.make!(:company => @i.company)
          }.should change(Invoice,:count).by(2)
        end
        it "is required if not blank" do
          @i = Invoice.make!(:xero_reference => 'test')
          @i2 = Invoice.make(:xero_reference => 'test', :company => @i.company)
          @i2.should_not be_valid
        end
        it "is scoped to company" do
          @i = Invoice.make!(:xero_reference => 'test')
          @i2 = Invoice.make(:xero_reference => 'test')
          @i2.should be_valid
        end

      end
    end
  end
end