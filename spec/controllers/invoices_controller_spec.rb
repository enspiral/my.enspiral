require 'spec_helper'

describe InvoicesController do
  let!(:person)               { Person.make!(:staff) }
  let!(:company)              { Company.make! }
  let!(:customer)             { Customer.make!(company: company) }
  let!(:invoice)              { Invoice.make!(company:company, amount: 10) }

  before(:each) do
    CompanyMembership.make!(company:company, person:person, admin:true)
    sign_in person.user
  end

  describe 'a project lead', focus: true do
    let!(:project)            { Project.make!(company: company) }
    let!(:invoice)            { Invoice.make!(company:company, amount: 10, project: project) }

    before :each do
      project.project_memberships.create!(person: person, is_lead:true)
    end

    it 'indexes project invoices' do
      get :index, project_id: project.id
      response.should be_success
      response.should render_template(:index)
      assigns(:invoices).should_not be_nil
    end

    it 'shows a project invoice', focus:true do
      get :show, project_id: project.id, id: invoice.id
      response.should be_success
      response.should render_template :show
      assigns(:invoice).should_not be_nil
    end

    it 'shows a new invoice form' do
      get :new, project_id: project.id
      response.should be_success
      response.should render_template :new
      assigns(:invoice).should_not be_nil
    end

    it 'shows a edit invoice form' do
      get :edit, project_id: project.id, id: invoice.id
      response.should be_success
      response.should render_template :edit
      assigns(:invoice).should_not be_nil
    end

    it 'creates invoices' do
      lambda{
      post :create, invoice: {amount: 5,
                              customer_id: customer.id,
                              date: '2011-11-11',
                              due: '2011-11-11'}, project_id: project.id
      }.should change(Invoice, :count).by(1)
      response.should be_redirect
      assigns(:invoice).project.should == project
    end

    it 'updates invoices' do
      put :update, invoice: {amount: 7}, project_id: project.id, id: invoice.id
      response.should be_redirect
      assigns(:invoice).amount.should == 7
    end

  end

  it 'indexes company invoices' do
    get :index, company_id: company.id
    response.should be_success
    response.should render_template(:index)
    assigns(:invoices).should_not be_nil
  end

  it 'shows a company invoice' do
    get :show, company_id: company.id, id: invoice.id
    response.should be_success
    response.should render_template :show
    assigns(:invoice).should_not be_nil
  end

  it 'shows a new invoice form' do
    get :new, company_id: company.id
    response.should be_success
    response.should render_template :new
    assigns(:invoice).should_not be_nil
  end

  it 'shows a edit invoice form' do
    get :edit, company_id: company.id, id: invoice.id
    response.should be_success
    response.should render_template :edit
    assigns(:invoice).should_not be_nil
  end

  it 'creates invoices' do
    lambda{
    post :create, invoice: {amount: 5,
                            customer_id: customer.id,
                            date: '2011-11-11',
                            due: '2011-11-11'}, company_id: company.id
    }.should change(Invoice, :count).by(1)
    response.should be_redirect
    assigns(:invoice).company.should == company
  end

  it 'updates invoices' do
    put :update, invoice: {amount: 7}, company_id: company.id, id: invoice.id
    response.should be_redirect
    assigns(:invoice).amount.should == 7
  end

  context 'an allocated invoice' do
    before do
      @account = company.accounts.create name: 'bucket'
      invoice.allocations.create amount: invoice.amount, account: @account
    end

    it 'closes an invoice' do
      post :close, company_id: company.id, id: invoice.id
      # how to i stub the method
      assigns(:invoice).should be_paid
      response.should be_redirect
    end
  end

  describe '#reverse' do

    context 'if one of the allocations can no longer be reversed' do

    end
  end

  def reverse
    invoice = Invoice.find(params[:id])
    reverseable = true
    invoice.allocations.each do |el|
      if !el.validate_reverse_payment
        reverseable = false
        break
      end
    end

    if reverseable
      invoice.allocations.each do |el|
        el.reverse_payment unless el.payments.empty?
      end
      invoice.allocations.destroy_all
      invoice.payments.destroy_all
      invoice.paid = false
      invoice.save!
      flash[:alert] = "Successfully make reverse payment"
    else
      flash[:error] = "Reverse Failed, Please check the minimum balance"
    end
    redirect_to [@invoiceable, invoice]
  end

end
