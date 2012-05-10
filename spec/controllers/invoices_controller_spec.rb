require 'spec_helper'

describe InvoicesController do
  before(:each) do
    @person = Person.make!(:staff)
    @company = Company.make!
    CompanyMembership.make!(company:@company, person:@person, admin:true)
    @customer = Customer.make!(company: @company)
    sign_in @person.user
    @invoice = Invoice.make!(company:@company, amount: 10)
  end

  describe 'a project lead', focus: true do
    before :each do
      @project = Project.make!(company: @company)
      @project.project_memberships.create!(person: @person, is_lead:true)
    end

    it 'indexes project invoices' do
      get :index, project_id: @project.id
      response.should be_success
      response.should render_template(:index)
      assigns(:invoices).should_not be_nil
    end

    it 'shows a project invoice' do
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
      }.should change(Invoice, :count).by(1)
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
    get :index, company_id: @company.id
    response.should be_success
    response.should render_template(:index)
    assigns(:invoices).should_not be_nil
  end

  it 'shows a company invoice' do
    get :show, company_id: @company.id, id: @invoice.id
    response.should be_success
    response.should render_template :show
    assigns(:invoice).should_not be_nil
  end

  it 'shows a new invoice form' do
    get :new, company_id: @company.id
    response.should be_success
    response.should render_template :new
    assigns(:invoice).should_not be_nil
  end

  it 'shows a edit invoice form' do
    get :edit, company_id: @company.id, id: @invoice.id
    response.should be_success
    response.should render_template :edit
    assigns(:invoice).should_not be_nil
  end

  it 'creates invoices' do
    lambda{
    post :create, invoice: {amount: 5,
                            customer_id: @customer.id,
                            date: '2011-11-11',
                            due: '2011-11-11'}, company_id: @company.id
    }.should change(Invoice, :count).by(1)
    response.should be_redirect
    assigns(:invoice).company.should == @company
  end

  it 'updates invoices' do
    put :update, invoice: {amount: 7}, company_id: @company.id, id: @invoice.id
    response.should be_redirect
    assigns(:invoice).amount.should == 7
  end

  describe 'disbursement' do
    context 'a paid invoice' do
      before :each do
        @allocation_params = {amount: 10, account: Account.make!, commission: 0.10}
        @invoice.payments.create!(amount: 10, paid_on: Date.today)
      end

      it 'disburses an entire invoice' do
        @allocation = @invoice.allocations.create! @allocation_params
        post :disburse, id: @invoice.id, company_id: @company.id
        response.should be_redirect
        flash[:notice].should =~ /Successfully disbused all allocations/
        assigns(:invoice).disbursed?.should be_true
      end

      it 'disburses individual allocations' do
        @allocation_params[:amount] = 5
        @allocation = @invoice.allocations.create! @allocation_params
        post :disburse, id: @invoice.id, :invoice_allocation_id => @allocation.id, company_id: @company.id
        flash[:notice].should =~ /Successfully disbused allocation/
        assigns(:invoice).amount_disbursed.should == 5
      end
    end

    context 'an unpaid invoice' do
      it 'does not disbuse' do
        @allocation_params = {amount: 10, account: Account.make!, commission: 0.10}
        @allocation = @invoice.allocations.create! @allocation_params
        post :disburse, id: @invoice.id, company_id: @company.id
        assigns(:invoice).disbursed?.should be_false
      end
    end
  end
  context 'pay and disburse' do
    before :each do
      @allocation_params = {amount: 10, account: Account.make!, commission: 0.10}
    end

    it 'creates payment and disburses an open invoice' do
      @allocation = @invoice.allocations.create! @allocation_params
      post :pay_and_disburse, id: @invoice.id, company_id: @company.id
      assigns(:invoice).disbursed?.should be_true
      assigns(:invoice).paid?.should be_true
    end
  end
end
