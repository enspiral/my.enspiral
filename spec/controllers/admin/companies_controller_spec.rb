require 'spec_helper'

describe Admin::CompaniesController do
  it 'requires an admin' do
    get :index
    response.should be_redirect
  end

  describe 'a system admin' do
    before :each do
      @person = Person.make!(:admin)
      sign_in @person.user
    end

    it 'indexes companies' do
      get :index
      assigns(:companies)
      response.should be_success
      response.should render_template('index')
    end

    it 'can see new company form' do
      get :new
      response.should be_success
      response.should render_template('new')
    end

    it 'can create a commpany' do
      post :create, company: {name: 'Enspiral Tacos',
                              default_contribution: '0.5'}
      response.should redirect_to admin_companies_path
      flash[:notice].should =~ /Created company/
      assigns(:company).should be_valid
      assigns(:company).admins.should include @person
    end

    it 'can destroy a company' do
      c = double(:company)
      c.should_receive(:destroy)
      Company.stub(:find).and_return(c)
      delete :destroy, :id => 5
    end
  end
end
