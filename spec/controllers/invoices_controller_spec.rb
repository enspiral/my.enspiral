require 'spec_helper'

describe InvoicesController do
  before(:each) do
    @person = Person.make!(:staff)
    @company = Enspiral::CompanyNet::Company.make!
    CompanyMembership.make!(company:@company, person:@person, admin:true)
    @customer = Customer.make!(company: @company)
    sign_in @person.user
    @invoice = Enspiral::MoneyTree::Invoice.make!(company:@company, amount: 10)
  end

  describe 'a project lead', focus: true do
    before :each do
      @project = Project.make!(company: @company)
      @project.project_memberships.create!(person: @person, is_lead:true)
      @invoice = Enspiral::MoneyTree::Invoice.make!(company:@company, amount: 10, project: @project)
    end

    it 'indexes project invoices' do
      get :index, project_id: @project.id
      response.should be_success
      response.should render_template(:index)
      assigns(:invoices).should_not be_nil
    end

    it 'shows a project invoice', focus:true do
      get :show, project_id: @project.id, id: @invoice.id
      response.should be_success
      response.should render_template :show
      assigns(:invoice).should_not be_nil
    end

    it 'shows a new invoice form' do
      get :new, project_id: @project.id
      response.should be_success
      response.should render_template :new
      assigns(:invoice).should_not be_nil
    end

    it 'shows a edit invoice form' do
      get :edit, project_id: @project.id, id: @invoice.id
      response.should be_success
      response.should render_template :edit
      assigns(:invoice).should_not be_nil
    end

    it 'creates invoices' do
      lambda{
      post :create, invoice: {amount: 5,
                              customer_id: @customer.id,
                              date: '2011-11-11',
                              due: '2011-11-11'}, project_id: @project.id
      }.should change(Enspiral::MoneyTree::Invoice, :count).by(1)
      response.should be_redirect
      assigns(:invoice).project.should == @project
    end

    it 'updates invoices' do
      put :update, invoice: {amount: 7}, project_id: @project.id, id: @invoice.id
      response.should be_redirect
      assigns(:invoice).amount.should == 7
    end

  end

  it 'indexes company invoices' do
    get :index, enspiral_company_net_company_id: @company.id
    response.should be_success
    response.should render_template(:index)
    assigns(:invoices).should_not be_nil
  end

  it 'shows a company invoice' do
    get :show, enspiral_company_net_company_id: @company.id, id: @invoice.id
    response.should be_success
    response.should render_template :show
    assigns(:invoice).should_not be_nil
  end

  it 'shows a new invoice form' do
    get :new, enspiral_company_net_company_id: @company.id
    response.should be_success
    response.should render_template :new
    assigns(:invoice).should_not be_nil
  end

  it 'shows a edit invoice form' do
    get :edit, enspiral_company_net_company_id: @company.id, id: @invoice.id
    response.should be_success
    response.should render_template :edit
    assigns(:invoice).should_not be_nil
  end

  it 'creates invoices' do
    lambda{
    post :create, invoice: {amount: 5,
                            customer_id: @customer.id,
                            date: '2011-11-11',
                            due: '2011-11-11'}, enspiral_company_net_company_id: @company.id
    }.should change(Enspiral::MoneyTree::Invoice, :count).by(1)
    response.should be_redirect
    assigns(:invoice).company.should == @company
  end

  it 'updates invoices' do
    put :update, invoice: {amount: 7}, enspiral_company_net_company_id: @company.id, id: @invoice.id
    response.should be_redirect
    assigns(:invoice).amount.should == 7
  end

  context 'an allocated invoice' do
    before do
      @account = @company.accounts.create name: 'bucket'
      @invoice.allocations.create amount: @invoice.amount, account: @account
    end

    it 'closes an invoice' do
      post :close, enspiral_company_net_company_id: @company.id, id: @invoice.id
      # how to i stub the method
      assigns(:invoice).should be_paid
      response.should be_redirect
    end
  end

end
