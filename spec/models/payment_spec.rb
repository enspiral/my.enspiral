require 'spec_helper'

describe Payment do
  let!(:company)                  { Company.make! }
  let!(:employee_account)         { company.accounts.create!(name: 'employee account') }
  let!(:customer)                 { company.customers.create! name: 'customer' }
  let!(:project)                  { company.projects.create! name: 'project',
                                                             customer: customer,
                                                             due_date: 30.days.from_now,
                                                             amount_quoted: 10000 }
  let!(:invoice_amount)           { 100 }
  let!(:invoice)                  { company.invoices.create! customer: customer,
                                                             project: project,
                                                             amount: 100,
                                                             date: Date.today,
                                                             due: 1.week.from_now }

  let!(:payment_amount)           { 50 }
  let!(:contribution)             { 0.2 }
  let!(:contribution_amount)      { payment_amount * contribution }
  let!(:remuneration_amount)      { payment_amount - contribution_amount }
  let!(:invoice_allocation)       { invoice.allocations.create!(
                                      account: employee_account,
                                      amount: invoice_amount,
                                      contribution: contribution) }
  let!(:author)                   { Person.make!(:staff) }

  before do
    CompanyMembership.create!(person: author, company: company, admin: true)
  end

  it {should validate_presence_of :author}
  it {should validate_presence_of :invoice}
  it {should validate_presence_of :invoice_allocation}
  it {should validate_presence_of :paid_on}
  it {should validate_presence_of :amount}


  it 'fails validation on amount too big' do
    payment = invoice.payments.create(
                author: author,
                amount: invoice_amount + 1,
                invoice_allocation: invoice_allocation)

    payment.should have(1).errors_on(:amount)
  end

  describe 'making a payment on an invoice allocation' do
    let!(:payment)            { invoice.payments.create!(
                                  author: author,
                                  amount: payment_amount,
                                  invoice_allocation: invoice_allocation) }

    describe 'creates cash in the income account', focus: true do
      subject { payment.new_cash_transaction }
      it { should be_valid }
      its(:amount) { should == payment_amount }
      its(:account) { should == company.income_account }
    end

    describe 'creates a renumeration funds transfer' do
      subject { payment.renumeration_funds_transfer }
      its(:destination_account) { should == employee_account }
      its(:source_account) { should == company.income_account }
      its(:amount) { should == remuneration_amount }
    end

    describe 'creates a contribution funds transfer' do
      subject { payment.contribution_funds_transfer }
      its(:destination_account) { should == company.support_account}
      its(:source_account) { should == company.income_account }
      its(:amount){ should == contribution_amount }
    end
  end

  describe '#reverse' do

    context 'if there is a team account supplied' do

      let!(:team_account)         { company.accounts.create!(name: "TEAM: Ghostbusters!") }

      before do
        invoice_allocation.update_attribute(:team_account_id, team_account.id)

        @payment = invoice.payments.create!(
                  author: author,
                  amount: invoice_amount,
                  invoice_allocation: invoice_allocation)
      end

      context 'if there is enough balance in the account for a reversal' do

        it 'should not fail' do
          @payment.reverse

          expect(invoice.reload.payments.count).to eq 0
        end

        it 'should restore the previous balance of the employee account' do
          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution))

          @payment.reverse

          expect(invoice_allocation.account.reload.balance).to eq(0)
        end

        it 'should modify the contribution account balance' do
          expect(company.support_account.reload.balance).to eq invoice_amount * contribution * 7/8

          @payment.reverse

          expect(invoice_allocation.account.reload.balance).to eq(0)
        end

        it 'should restore the team account balance' do
          expect(team_account.reload.balance).to eq (invoice_amount * contribution / 8)

          @payment.reverse

          expect(team_account.reload.balance).to eq(0)
        end

      end

      context 'if there is not enough balance in the account for a reversal' do

        let!(:other_account)         { company.accounts.create!(name: "someone else's account") }

        before do
          ft = FundsTransfer.new(author: author, amount: 50, description: "50 kg of pickled figs", date: Time.now, source_account: employee_account, destination_account: other_account)
          Transaction.new(account: employee_account, amount:  -50, description: "50 kg of pickled figs",
                          creator: author, date: 2.days.ago)
          Transaction.new(account: other_account, amount:  50, description: "50 kg of pickled figs",
                          creator: author, date: 2.days.ago)
          ft.save!
        end

        it 'should fail' do
          expect{@payment.reverse}.to raise_error

          expect(invoice.payments.count).to eq 1
        end

        it 'should not modify the account balance' do
          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution) - 50)

          expect{@payment.reverse}.to raise_error

          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution) - 50)
        end

        it 'should not modify the contribution account balance' do
          expect(company.support_account.reload.balance).to eq invoice_amount * contribution * 7/8

          expect{@payment.reverse}.to raise_error

          expect(company.support_account.reload.balance).to eq invoice_amount * contribution * 7/8
        end

        it 'should not modify the team account balance' do
          expect(team_account.reload.balance).to eq invoice_amount * contribution / 8

          expect{@payment.reverse}.to raise_error

          expect(team_account.reload.balance).to eq invoice_amount * contribution / 8
        end

      end
    end

    context 'if there is no team account supplied' do

      let!(:payment)            { invoice.payments.create!(
                                    author: author,
                                    amount: invoice_amount,
                                    invoice_allocation: invoice_allocation)}

      context 'if there is enough balance in the account for a reversal' do

        it 'should not fail' do
          payment.reverse
        end

        it 'should restore the previous balance of the employee account' do
          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution))

          payment.reverse

          expect(invoice_allocation.account.reload.balance).to eq(0)
        end

        it 'should not modify the contribution account balance' do
          expect(company.support_account.reload.balance).to eq(invoice_amount * contribution)

          payment.reverse

          expect(invoice_allocation.account.reload.balance).to eq(0)
        end

      end

      context 'if there is not enough balance in the account for a reversal' do

        let!(:other_account)         { company.accounts.create!(name: "someone else's account") }

        before do
          ft = FundsTransfer.new(author: author, amount: 50, description: "50 kg of pickled figs", date: Time.now, source_account: employee_account, destination_account: other_account)
          Transaction.new(account: employee_account, amount:  -50, description: "50 kg of pickled figs",
                          creator: author, date: 2.days.ago)
          Transaction.new(account: other_account, amount:  50, description: "50 kg of pickled figs",
                          creator: author, date: 2.days.ago)
          ft.save!
        end

        it 'should fail' do
          expect{payment.reverse}.to raise_error
        end

        it 'should not modify the account balance' do
          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution) - 50)

          expect{payment.reverse}.to raise_error

          expect(invoice_allocation.account.reload.balance).to eq(invoice_amount - (invoice_amount * contribution) - 50)
        end

        it 'should not modify the contribution account balance' do
          expect(company.support_account.reload.balance).to eq(invoice_amount * contribution)

          expect{payment.reverse}.to raise_error

          expect(company.support_account.reload.balance).to eq(invoice_amount * contribution)
        end

      end
    end
  end
end
