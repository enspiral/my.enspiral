require 'spec_helper'

describe Invoice do
  before(:each) do
    @invoice = Invoice.make!(amount: 10)
  end

  context 'a new invoice' do
    it 'is not paid' do
      @invoice.paid?.should be_false
    end

    it 'is not allocated' do
      @invoice.allocated?.should be_false
    end

    it 'is not disbursed' do
      @invoice.disbursed?.should be_false
    end
  end
  
  context 'payments' do
    it 'is paid when payments meet amount' do
      @invoice.payments.create!(amount: 10, paid_on: Date.today)
      @invoice.paid?.should be_true
    end

    it 'is not paid when payments less than amount' do
      @invoice.payments.create!(amount: 9, paid_on: Date.today)
      @invoice.paid?.should be_false
    end
  end

  describe 'allocations' do
    before :each do
      @account = Account.make!
      @person = Person.make!
    end
    it 'is allocated when allocations meet amount' do
      @invoice.allocations.create!(account: @account, amount: 10, commission: 0)
      @invoice.allocated?.should be_true
    end

    it 'is not allocated when allocations less than amount' do
      @invoice.allocations.create!(account: @account, amount: 9, commission: 0)
      @invoice.allocated?.should be_false
    end

    it 'should not be valid if over allocated' do
      @allocation = @invoice.allocations.create(account: @account, amount: 11, commission: 0)
      @allocation.should have(1).errors_on(:amount)
    end

    it 'should disburse individual allocations' do
      @allocation = @invoice.allocations.create!(account: @account, amount: 10, commission: 0)
      lambda{ @allocation.disburse!(@person) }.should change(@account, :balance).from(0).to(10)
    end

    it 'is disbursed when disbursement meets amount' do
      @allocation = @invoice.allocations.create!(account: @account, amount: 10, commission: 0)
      @allocation.disburse!(@person)
      @invoice.reload
      @invoice.disbursed?.should be_true
    end

  end

  describe "an unpaid invoice" do
    describe "with 1 allocation" do
      before(:each) do
        person = Person.make
        person.save!
        @allocation = make_invoice_allocation_for(@invoice, person)
      end

      it "should have many invoice_allocations" do
        @invoice.allocations.should include(@allocation)
      end

      it "should destroy the allocations when destroyed" do
        @invoice.destroy
        lambda { @allocation.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not allow a paid invoice to be destroyed" do
        @invoice.payments.create!(amount: 10, paid_on: Date.today)
        lambda { @invoice.destroy }.should raise_error
      end
    end
  end
end
