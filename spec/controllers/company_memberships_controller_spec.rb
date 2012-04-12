require 'spec_helper'

describe CompanyMembershipsController do

  before :each do
    @company = Company.make!
    @person = Person.make!
    sign_in @person.user
  end

  context 'a non company administator' do
    it 'raises an error when loading a company' do
      lambda{
        get :index, company_id: @company.id
      }.should raise_error
    end
  end

  context 'as company administrator' do
    before :each do
      @membership = @company.company_memberships.create(person: @person, admin: true)
    end

    it 'indexes memberships' do
      get :index, company_id: @company.id
      response.should be_success
      response.should render_template('index')
      assigns(:memberships).should include @membership
    end

    it 'shows new membership form' do
      get :new, company_id: @company.id
      response.should be_success
      response.should render_template('new')
    end

    it 'shows edit membership form' do
      get :edit, id: @membership.id, company_id: @company.id
      response.should be_success
      response.should render_template('edit')
    end

    it 'can create memberships' do
      lambda{
        post :create, person_id: @person.id, company_id: @company.id
      }.should change(CompanyMembership, :count).by(1)
      response.should redirect_to company_memberships_path(@company)
      flash[:notice].should =~ /Membership created/
      assigns(:membership).should be_valid
    end

    it 'can update memberships' do
      put :update, id: @membership.id, company_membership:{admin: 'false'},
          company_id: @company.id
      response.should be_redirect
      assigns(:membership).admin.should be_false
      flash[:notice].should =~ /Membership updated/
    end

    it 'can destroy memberships' do
      delete :destroy, id: @membership.id, company_id: @company.id
      assigns(:membership).should_not be_persisted
    end
  end
end
