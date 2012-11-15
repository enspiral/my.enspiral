require 'spec_helper'

describe CustomersController do
  before(:each) do
    @company = Enspiral::CompanyNet::Company.make!
    @person = Person.make!(:staff)
    CompanyMembership.make!(company: @company, person: @person, admin: true)
    @customer = Customer.make!(company: @company)
    log_in @person.user
  end

  it 'indexes company customers' do
    get :index, enspiral_company_net_company_id: @company.id
    response.should be_success
    response.should render_template(:index)
    assigns(:customers).should_not be_nil
  end

  it 'shows a company customer' do
    get :show, enspiral_company_net_company_id: @company.id, id: @customer.id
    response.should be_success
    response.should render_template :show
    assigns(:customer).should_not be_nil
  end

  it 'shows a new customer form' do
    get :new, enspiral_company_net_company_id: @company.id
    response.should be_success
    response.should render_template :new
    assigns(:customer).should_not be_nil
  end

  it 'shows a edit customer form' do
    get :edit, enspiral_company_net_company_id: @company.id, id: @customer.id
    response.should be_success
    response.should render_template :edit
    assigns(:customer).should_not be_nil
  end

  it 'creates customers' do
    lambda{
    post :create, customer: {name: 'mcdonalds', company_id: @company.id}
    }.should change(Customer, :count).by(1)
    response.should be_redirect
    assigns(:customer).company.should == @company
  end

  it 'updates customers' do
    put :update, customer: {name: 'figgyies'}, company_id: @company.id, id: @customer.id
    response.should be_redirect
    assigns(:customer).name.should == 'figgyies'
  end
end
