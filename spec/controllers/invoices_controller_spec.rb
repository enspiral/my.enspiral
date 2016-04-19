require 'spec_helper'

describe InvoicesController do
  let!(:person)               { Person.make!(:staff) }
  let!(:admin)                { Person.make!(:staff) }
  let!(:company)              { Company.make! }
  let!(:customer)             { Customer.make!(company: company) }
  let!(:invoice)              { Invoice.make!(company:company, amount: 10) }

  before(:each) do
    CompanyMembership.make!(company:company, person:person, admin:true)
    sign_in person.user
  end

  describe 'a project lead' do
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

    let!(:account)                  { Account.make!(name: "#{person.name}'s Enspiral Services Account'", company: company) }
    let!(:allocation)               { InvoiceAllocation.create(invoice: invoice, currency: "NZD", account: account, amount: 10) }

    let!(:balance_before_payment)   { account.balance }

    before do
      invoice.close!(admin)
      @balance_after_payment = account.reload.balance
    end

    context 'if payments against all allocations can be reversed' do

      it 'should be successful' do
        post :reverse, company_id: company.id, id: invoice.id

        expect(invoice.reload.paid).to be_false
        expect(invoice.paid_on).to be_nil
        expect(balance_before_payment).to eq account.reload.balance
        expect(invoice.payments.count).to eq 0
      end

      it 'must not remove the allocations' do
        post :reverse, company_id: company.id, id: invoice.id

        expect(invoice.allocations.count).to eq 1
      end

    end

    context 'if one of the allocations can no longer be reversed' do

      let!(:other_account)          { Account.make!(name: "Hot Sauce Fundraiser", company: company) }

      before do
        ft = FundsTransfer.new(author: person, amount: 5, description: "50 kg of hot sauce", date: Time.now, source_account: account, destination_account: other_account)
        Transaction.new(account: account, amount:  -6, description: "50 kg of hot sauce",
                        creator: person, date: 2.days.ago)
        Transaction.new(account: other_account, amount:  6, description: "50 kg of hot sauce",
                        creator: person, date: 2.days.ago)
        ft.save!
      end

      it 'should fail' do
        post :reverse, company_id: company.id, id: invoice.id

        expect(balance_before_payment).to_not eq account.balance
        expect(invoice.paid).to be_true
        expect(invoice.reload.payments.count).to eq 1
      end

    end
  end

end
