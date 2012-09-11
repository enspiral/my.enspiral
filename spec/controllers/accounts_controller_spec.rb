require 'spec_helper'

describe AccountsController do

  before :each do
    @company = Company.create!(name: 'nike')
    @person = Person.make!(:staff)
    @person.companies << @company
    sign_in @person.user
    @account = Account.make!(company: @company)
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

    it 'shows new account form' do
      get :new
      response.should be_success
      response.should render_template :new
    end

    it 'creates account' do
      post :create, account: {name: 'newaccount',
                              accounts_people_attributes: {'0' => {person_id: @person.id}},
                              company_id: @person.companies.first.id }

      response.should be_redirect
      assigns(:account).should be_persisted
      assigns(:account).should be_valid
      assigns(:account).people.should include @person
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

    it 'shows an edit form' do
      get :edit, id: @account.id
      response.should be_success
      response.should render_template :edit
    end
    
    it 'updates the account' do
      put :update, id: @account.id, account: {public: true}
      response.should be_redirect
      assigns(:account).public.should be_true
    end

    it 'updates the account but will not allow you to change company_id' do
      @newcomp = Company.make!
      put :update, id: @account.id, account: {public: true, company_id: @newcomp.id}
      response.should be_redirect
      assigns(:account).public.should be_true
      assigns(:account).company_id.should == @company.id
    end

    describe "balances" do
      before :each do
        @person.accounts << @account
        make_financials(@person, @account)
      end
      it "without a limit should return all them" do
        get :balances, :account_id => @account.id
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end

      it "with a limit should return a subset of balances" do
        get :balances, :limit => 2, :account_id => @account.id
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

    it 'shows new account form' do
      get :new, company_id: @company.id
      response.should be_success
      response.should render_template :new
    end

    it 'creates account' do
      post :create, company_id: @company.id, account: {name: 'newaccount', company_id: @company.id}
      response.should be_redirect
      assigns(:account).should be_persisted
      assigns(:account).should be_valid
      assigns(:account).company.should == @company
      assigns(:account).people.should be_empty
    end

    it 'shows a company account' do
      get :show, id: @account.id, company_id: @company.id
      response.should be_success
      response.should render_template :show
      assigns(:account).should == @account
    end
  end

  context 'public' do
    before :each do
      @account = Account.make!(company: @company, public: true)
    end

    it 'indexes public accounts' do
      get :public
      assigns(:accounts).should include @account
      response.should render_template(:index)
    end

    it 'shows a public account' do
      get :show, id: @account.id
      response.should be_success
    end
  end
end
