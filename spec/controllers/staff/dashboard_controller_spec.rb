require 'spec_helper'

describe Staff::DashboardController do
  describe "staff member" do
    before(:each) do
      @person = Person.make!
      log_in @person.user

      make_financials(@person)
    end

    describe "GET 'dashboard'" do
      it "should be successful" do
        get 'dashboard'
        response.should be_success
        assigns(:person).should == @person
      end

      it "should collect peoples financial data" do
        get 'dashboard'
        assigns(:transactions).should == Transaction.transactions_with_totals(@person.account.transactions)[0..9]
      end

      it "should tally totals" do
        get 'dashboard'
        assigns(:invoice_allocations).should == @person.invoice_allocations.pending
        assigns(:pending_total).should == @person.pending_total
      end
    end

    describe "GET 'history'" do
      it "should be successful" do
        get 'history'
        response.should be_success
        assigns(:person).should == @person
      end

      it "should collect peoples financial data" do
        get 'history'
        assigns(:transactions).should == Transaction.transactions_with_totals(@person.account.transactions)
      end

      it "should tally totals" do
        get 'history'
        assigns(:pending_total).should == @person.pending_total
      end
    end
  end
end
