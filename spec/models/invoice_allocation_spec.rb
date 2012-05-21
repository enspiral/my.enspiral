require 'spec_helper'

describe InvoiceAllocation do
  describe "an undisbursed allocation" do
    before(:each) do
      @company = Company.create!(name: 'testco', default_commission: 0.2)
      @customer = Customer.make!(company: @company)
      @invoice = Invoice.make!(company: @company, customer: @customer)
      @account = Account.make!(company: @company)
      @ia = @invoice.allocations.create(account: @account, amount: @invoice.amount)
    end

    it "is not disbursed" do
      @ia.disbursed.should be_false
    end

    it "should show the correct amount allocated" do
      @ia.amount_allocated.should < @ia.amount
    end

    it "should create 2 FundsTransfers when disbursed" do
      @author = Person.make!
      payment = @invoice.payments.create!(amount: @invoice.amount, paid_on: Date.today)
      lambda {
        @ia.disburse!(@author)
      }.should change { FundsTransfer.count }.by(2)
    end

    describe "a disbursed allocation" do
      before(:each) do
        @author = Person.make!
        payment = @invoice.payments.create!(amount: @invoice.amount, paid_on: Date.today)
        @ia.disburse!(@author)
      end

      it "should not be able to be redisbursed" do
        lambda {
          @ia.disburse!(@author)
        }.should_not change {Transaction.count}
      end

      it "should set disbursed attribute" do
        @ia.disbursed?.should be_true
      end
    end
  end
end
