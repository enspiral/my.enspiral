require 'spec_helper'

module Enspiral
  module MoneyTree
    describe Payment do
      before :each do
        @company = Company.make!
        @employee_account = @company.accounts.create!(
                              name: 'employee account')

        @customer = @company.customers.create! name: 'customer'

        @project = @company.projects.create! name: 'project',
                                             customer: @customer,
                                             due_date: 30.days.from_now,
                                             amount_quoted: 10000

        @invoice_amount = 100
        @invoice = @company.invoices.create! customer: @customer,
                                            project: @project,
                                            amount: 100,
                                            date: Date.today,
                                            due: 1.week.from_now

        @payment_amount = 50
        @contribution = 0.2
        @contribution_amount = @payment_amount * @contribution
        @renumeration_amount = @payment_amount - @contribution_amount

        @invoice_allocation  = @invoice.allocations.create!(
                                  account: @employee_account,
                                  amount: @invoice_amount,
                                  contribution: @contribution)
        @author = Person.make!(:staff)
        CompanyMembership.create!(person: @author, company: @company, admin: true)
      end

      it {should validate_presence_of :author}
      it {should validate_presence_of :invoice}
      it {should validate_presence_of :invoice_allocation}
      it {should validate_presence_of :paid_on}
      it {should validate_presence_of :amount}


      it 'fails validation on amount too big' do
        @payment = @invoice.payments.create(
                    author: @author,
                    amount: @invoice_amount + 1,
                    invoice_allocation: @invoice_allocation)
        @payment.should have(1).errors_on(:amount)
      end

      describe 'making a payment on an invoice allocation' do
        before do
          @payment = @invoice.payments.create!(
                      author: @author,
                      amount: @payment_amount,
                      invoice_allocation: @invoice_allocation)
        end

        describe 'creates cash in the income account', focus: true do
          subject { @payment.new_cash_transaction }
          it { should be_valid }
          its(:amount) { should == @payment_amount }
          its(:account) { should == @company.income_account }
        end

        describe 'creates a renumeration funds transfer' do
          subject { @payment.renumeration_funds_transfer }
          its(:destination_account) { should == @employee_account }
          its(:source_account) { should == @company.income_account }
          its(:amount) { should == @renumeration_amount }
        end

        describe 'creates a contribution funds transfer' do
          subject { @payment.contribution_funds_transfer }
          its(:destination_account) { should == @company.support_account}
          its(:source_account) { should == @company.income_account }
          its(:amount){ should == @contribution_amount }
        end
      end
    end
  end
end