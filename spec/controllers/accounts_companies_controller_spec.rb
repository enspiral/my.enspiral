require 'spec_helper'

describe AccountsCompaniesController do

  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
    @newcompany = Company.make!
    @account = Account.make!
    @company = Company.make!
    @account.companies << @company
  end

  context 'person who owns account' do
    before :each do
      @account.people << @person
    end

    it 'can add companies to account' do
      post :create, :account_id => @account.id, :accounts_company => {:company_id => @newcompany.id}
      response.should be_redirect
      @account.reload
      @account.companies.should include @newcompany
    end

    it 'can remove companies from account' do
      @acct_prm = @account.accounts_companies.create!(company_id: @newcompany.id)
      delete :destroy, :id => @acct_prm.id, :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account companies/
      @account.companies.should_not include @newcompany
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id
      response.should be_success
      assigns(:accounts_company).should_not be_nil
    end
  end

  context 'person who is company admin' do
    before :each do
      CompanyMembership.make!(company:@company, person:@person, admin:true)
    end

    it 'can add companies to account' do
      post :create, :company_id => @company.id,
                    :account_id => @account.id,
                    :accounts_company => {:company_id => @newcompany.id}
      response.should be_redirect
      @account.reload
      @account.companies.should include @newcompany
    end

    it 'can remove companies from account' do
      @acct_prm = @account.accounts_companies.create!(company_id: @newcompany.id)
      delete :destroy, :id => @acct_prm.id,
                       :company_id => @company.id,
                       :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account companies/
      @account.companies.should_not include @newcompany
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id, :company_id => @company.id
      response.should be_success
      assigns(:accounts_companies).should_not be_nil
    end
  end

  context 'person who does not own account' do
    it 'cannot modify or view account permissions' do
      get :index, :account_id => @account.id, :company_id => @company.id
      response.should be_redirect
      flash[:alert].should =~ /You are not an owner of the account/
    end
  end

end
