require 'spec_helper'

describe Admin::DashboardController do
  describe "admin member" do
    before(:each) do
      person = Person.make!(:admin)
      log_in person.user
      
      make_test_financials
    end

    describe "GET 'dashboard'" do
      it "should be successful" do
        get 'dashboard'
        response.should be_success
      end

      it "should collect peoples financial data" do
        get 'dashboard'
        first_pad = assigns(:peoples_account_data)[0]
        first_pad[:person].should == @person_2
        first_pad[:transactions].should == Transaction.transactions_with_totals(@person_2.account.transactions)
        first_pad[:invoice_allocations].should == @person_2.invoice_allocations.pending
        first_pad[:pending_total].should == @person_2.pending_total
      end

      it "should tally totals" do
        get 'dashboard'
        assigns(:enspiral_pending_total).should == @person_1.pending_total + @person_2.pending_total + @person_3.pending_total
        assigns(:enspiral_balance).should == @account_1.balance + @account_2.balance + @account_3.balance
      end
    end

    describe "GET 'enspiral_balances'" do
      it "should be successful" do
        get 'enspiral_balances'
        response.should be_success
      end

      it "should return the data set of sum of each transaction per day" do
        get 'enspiral_balances'
        response.body.should == "[[\"1297767600000\",\"-100.0\"],[\"1297681200000\",\"0.0\"],[\"1297681200000\",\"-100.0\"],[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"-100.0\"],[\"1297594800000\",\"-200.0\"],[\"1297508400000\",\"-100.0\"],[\"1297508400000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end
    end
  end
end
