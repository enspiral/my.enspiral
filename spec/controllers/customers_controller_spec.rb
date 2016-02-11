require 'spec_helper'

describe CustomersController do
  before(:each) do
    @company = Company.make!
    @person = Person.make!(:staff)
    CompanyMembership.make!(company: @company, person: @person, admin: true)
    @customer = Customer.make!(company: @company)
    log_in @person.user
  end

  it 'indexes company customers' do
    get :index, company_id: @company.id
    response.should be_success
    response.should render_template(:index)
    assigns(:customers).should_not be_nil
  end

  it 'shows a company customer' do
    get :show, company_id: @company.id, id: @customer.id
    response.should be_success
    response.should render_template :show
    assigns(:customer).should_not be_nil
  end

  it 'shows a new customer form' do
    get :new, company_id: @company.id
    response.should be_success
    response.should render_template :new
    assigns(:customer).should_not be_nil
  end

  it 'shows a edit customer form' do
    get :edit, company_id: @company.id, id: @customer.id
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

  context 'approving customers' do
    it 'with no invoice given' do
      post :approve, company_id: @company.id, id: @customer.id
      response.should redirect_to company_invoices_path(@company)
      expect(@customer.reload.approved?).to be_true
    end

    context 'with an invoice given' do
      let!(:invoice)    { Invoice.make!(customer: @customer, company: @company) }

      it 'should approve the customer' do
        post :approve, company_id: @company.id, id: @customer.id, invoice_id: invoice.id
        expect(@customer.reload.approved?).to be_true
      end

      it 'should redirect to the invoice' do
        post :approve, company_id: @company.id, id: @customer.id, invoice_id: invoice.id
        expect(response).to redirect_to customer_invoice_url(@customer, invoice)
      end
    end
  end
end
