require 'spec_helper'

describe Staff::AccountsController do
    before(:each) do
      @person = Person.make!
      log_in @person.user
      make_financials(@person)
      @account = @person.account
    end

    describe 'index' do
      before :each do
        get :index
      end

      it 'list accounts you own' do
        assigns(:owned).should be_present
      end
      it 'lists public accounts', :focus => true do
        assigns(:public).should_not be_nil
      end
    end

    describe "GET 'history'" do
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

    describe "balances" do
      it "without a limit should return all them" do
        get :balances, :id => @account.id
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end

      it "with a limit should return a subset of balances" do
        get :balances, :limit => 2, :id => @account.id
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"]]"
      end

      it "should only allow the view of their own blances" do
        pending
        another_person = Person.make!
        Transaction.make!(:account => another_person.account, :date => Date.parse("2011-02-13"), :amount => 250)
        Transaction.make!(:account => another_person.account, :date => Date.parse("2011-02-14"), :amount => -250)

        get :balances
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end
    end

end
