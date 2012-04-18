require 'spec_helper'

describe Staff::AccountPermissionsController do
  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
    @newguy = Person.make!
    @account = Account.make!
  end

  context 'person who owns account' do
    before :each do
      @account.owners << @person
    end

    it 'can add owners to account' do
      post :create, :account_id => @account.id, :account_permission => {:person_id => @newguy.id}
      response.should be_redirect
      @account.reload
      @account.owners.should include @newguy
    end

    it 'can remove owners from account' do
      @acct_prm = @account.account_permissions.create!(person_id: @newguy.id)
      delete :destroy, :id => @acct_prm.id, :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account owners/
      @account.owners.should_not include @newguy
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id
      response.should be_success
      assigns(:account_permissions).should_not be_nil
    end
  end

  context 'user who is an admin' do
    before :each do
      @person = Person.make!(:admin)
      sign_in @person.user
    end

    it 'can add owners to account' do
      post :create, :account_id => @account.id, :account_permission => {:person_id => @newguy.id}
      response.should be_redirect
      @account.reload
      @account.owners.should include @newguy
    end

    it 'can remove owners from account' do
      @acct_prm = @account.account_permissions.create!(person_id: @newguy.id)
      delete :destroy, :id => @acct_prm.id, :account_id => @account.id
      response.should be_redirect
      @account.reload
      flash[:notice].should =~ /removed from account owners/
      @account.owners.should_not include @newguy
    end

    it 'can list permissions of account' do
      get :index, :account_id => @account.id
      response.should be_success
      assigns(:account_permissions).should_not be_nil
    end
  end

  context 'person who does not own account' do
    it 'cannot modify or view account permissions' do
      get :index, :account_id => @account.id
      response.should be_redirect
      flash[:alert].should =~ /You are not an owner of the account/
    end
  end

end
