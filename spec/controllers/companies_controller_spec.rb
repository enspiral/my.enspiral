require 'spec_helper'

describe CompaniesController do

  before :each do
    @person = Person.make!
    @company = Company.make!
    @membership = @company.company_memberships.create(person: @person)
    sign_in @person.user
  end

  it 'lists companies you belong to' do
    get :index
    response.should be_success
    response.should render_template('index')
    assigns(:companies).should include @company
  end

  context 'for a company admin' do
    before :each do
      @membership.update_attribute(:admin, true)  
    end

    it 'lists companies you administer' do
      get :index
      response.should be_success
      response.should render_template('index')
      assigns(:admin_companies).should include @company
    end

    it 'shows company edit form' do
      get :edit, id: @company.id
      response.should be_success
      response.should render_template('edit')
      assigns(:company).should_not be_nil
    end

    it 'updates company' do
      put :update, company: {name: 'new name'}, id: @company.id
      response.should be_redirect
      assigns(:company).should be_valid
      assigns(:company).name.should == 'new name'
    end

    it 'shows company' do
      get :show, id: @company.id
      response.should be_success
      response.should render_template :show
    end
  end

  context 'for a non company admin' do
    it 'does not show company edit form' do
      lambda{ get :edit, id: @company.id }.should raise_error
    end

    it 'does not updates company' do
      lambda{
        put :update, company: {name: 'new name'}, id: @company.id
      }.should raise_error
    end

    it 'it does not show company' do
      lambda{ get :show, id: @company.id }.should raise_error
    end
  end

end
