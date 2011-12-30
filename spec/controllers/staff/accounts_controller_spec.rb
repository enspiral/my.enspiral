require 'spec_helper'

describe Staff::AccountsController do
    before(:each) do
      @person = Person.make!
      log_in @person.user

      make_financials(@person)
    end

    describe "GET 'history'" do
      before(:each) do
        @account = @person.account
      end
      it "should be successful" do
        get 'history', :id => @account.id
        response.should be_success
        assigns(:account).should == @account
      end

      it "should collect peoples financial data" do
        get 'history', :id => @account.id
        assigns(:transactions).should == Transaction.transactions_with_totals(@account.transactions)
      end

      it "should tally totals" do
        get 'history', :id => @account.id
        assigns(:pending_total).should == @account.pending_total
      end
    end

end
