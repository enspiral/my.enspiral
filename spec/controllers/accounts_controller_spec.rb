require 'spec_helper'

describe AccountsController do

  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
    @account = Account.make!
  end

  it 'requires you to own the account' do 
    # note: account not added to person.accounts
    get :show, :id => @account.id
    response.should be_redirect
    flash[:alert].should =~ /Account not found/
  end

  context 'personal' do
    before :each do
      @person.accounts << @account
    end

    it 'indexes your accounts' do
      get :index
      response.should be_success
      response.should render_template :index
      assigns(:accounts).should include @account
    end

    it 'shows the acount' do
      get :show, id: @account.id
      response.should be_success
      response.should render_template :show
    end

    describe "GET 'history'" do
      before :each do
        @person.account = @account
        make_financials(@person, @account)
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

    describe "balances" do
      before :each do
        @person.account = @account
        make_financials(@person, @account)
      end
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

  context 'company' do
    before :each do
      @company = Company.make!
      @company.accounts << @account
      CompanyMembership.make!(company: @company, person: @person, admin: true)
    end

    it 'indexes company accounts' do
      get :index, company_id: @company.id
      response.should be_success
      response.should render_template :index
      assigns(:accounts).should include @account
    end

    it 'shows a company account' do
      get :show, id: @account.id, company_id: @company.id
      response.should be_success
      response.should render_template :show
      assigns(:account).should == @account
    end
  end

end
