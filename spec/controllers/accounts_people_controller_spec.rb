require 'spec_helper'

describe AccountsPeopleController do
  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
    @newguy = Person.make!
    @account = Account.make!
    @company = Company.make!
    @account.companies << @company
  end

  context 'person who owns account' do
    before :each do
      @account.people << @person
    end

    it 'can add people to account' do
      post :create, :account_id => @account.id, :accounts_person => {:person_id => @newguy.id}
      response.should be_redirect
      @account.reload
      @account.people.should include @newguy
    end

    it 'can remove people from account' do
      @acct_prm = @account.accounts_people.create!(person_id: @newguy.id)
      delete :destroy, :id => @acct_prm.id, :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account people/
      @account.people.should_not include @newguy
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id
      response.should be_success
      assigns(:accounts_person).should_not be_nil
    end
  end

  context 'person who is company admin' do
    before :each do
      CompanyMembership.make!(company:@company, person:@person, admin:true)
    end

    it 'can add people to account' do
      post :create, :company_id => @company.id,
                    :account_id => @account.id,
                    :accounts_person => {:person_id => @newguy.id}
      response.should be_redirect
      @account.reload
      @account.people.should include @newguy
    end

    it 'can remove people from account' do
      @acct_prm = @account.accounts_people.create!(person_id: @newguy.id)
      delete :destroy, :id => @acct_prm.id,
                       :company_id => @company.id,
                       :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account people/
      @account.people.should_not include @newguy
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id, :company_id => @company.id
      response.should be_success
      assigns(:accounts_people).should_not be_nil
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
