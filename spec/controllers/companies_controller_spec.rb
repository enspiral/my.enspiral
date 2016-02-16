require 'spec_helper'

describe CompaniesController do

  before(:each) do
    @company = Company.make!
    @person = Person.make!(:staff)
    CompanyMembership.make!(company: @company, person: @person, admin: true)
    log_in @person.user
  end

  describe '#index GET' do

    it 'should serve a list of companies' do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns(:companies).should_not be_nil
    end

  end

  describe '#show GET' do

    it 'successfully renders the show page' do
      get :show, id: @company.id
      response.should be_success
      response.should render_template :show
      assigns(:company).should_not be_nil
    end

  end

  describe '#edit GET' do

    it 'shows a edit customer form' do
      get :edit, id: @company.id
      response.should be_success
      response.should render_template :edit
      assigns(:company).should_not be_nil
    end

  end

  describe '#update' do

    it 'updates a company successfully' do
      put :update, company: {name: 'wendys'}, id: @company.id
      response.should be_redirect
      assigns(:company).name.should == 'wendys'
    end

  end

  describe '#xero_import_dashboard' do

    it 'successfully renders the dashboard' do
      get :xero_import_dashboard, id: @company.id
      response.should be_success
      response.should render_template :xero_import_dashboard
      assigns(:company).should_not be_nil
      response.body.should_not match /its Xero equivalent/
    end

    it 'successfully renders the dashboard' do
      get :xero_import_dashboard, id: @company.id, imported_invoice_id: ""
      response.should be_success
      response.should render_template :xero_import_dashboard
      assigns(:company).should_not be_nil
      response.body.should_not match /its Xero equivalent/
    end

    context 'when the user has just successfully imported an invoice' do

      let!(:invoice) { Invoice.make!(company: @company) }

      it 'should provide a link to the invoice' do
        get :xero_import_dashboard, id: @company.id, imported_invoice_id: invoice.id
        response.should be_success
        response.should render_template :xero_import_dashboard
        assigns(:imported_invoice).id.should eq invoice.id
        response.body.should match /its Xero equivalent/
      end

    end

  end

  describe '#xero_import_single' do

    context 'when import is successful' do
      it 'successfully renders the dashboard' do
        get :xero_import_dashboard, id: @company.id
        response.should be_success
        response.should render_template :xero_import_dashboard
        assigns(:company).should_not be_nil
      end
    end

    context 'when blank id and reference are supplied' do
      before do
        Company.any_instance.stub(:import_xero_invoice_by_reference) { raise ArgumentError.new }
      end

      it 'reports an error' do
        get :xero_import_single, id: @company.id
        response.should be_redirect
        assigns(:invoice).should be_nil
        flash[:error].should match /Xero Reference and ID are blank/
      end
    end

    context "when the invoice doesn't exist in xero" do
      before do
        Company.any_instance.stub(:import_xero_invoice_by_reference) { raise Xeroizer::InvoiceNotFoundError.new }
      end

      it 'reports an error' do
        get :xero_import_single, id: @company.id, xero_ref: "1234"
        response.should be_redirect
        assigns(:invoice).should be_nil
        flash[:error].should match /That invoice doesn't seem to exist in Xero/
      end
    end

    context 'when there is an error saving the new invoice' do
      before do
        Company.any_instance.stub(:import_xero_invoice_by_reference) { raise ActiveRecord::RecordInvalid.new(double.as_null_object) }
      end

      it 'reports an error' do
        get :xero_import_single, id: @company.id, xero_ref: "1000"
        response.should be_redirect
        assigns(:invoice).should be_nil
        flash[:error].should match /That invoice couldn't be saved/
      end
    end

    context "if there is some other error" do
      before do
        Company.any_instance.stub(:import_xero_invoice_by_reference) { raise FakeError.new }
      end

      it 'reports an error' do
        get :xero_import_single, id: @company.id, xero_ref: "1000"
        response.should be_redirect
        assigns(:invoice).should be_nil
        flash[:error].should match /can't determine the error/
      end
    end

  end

end

class FakeError < StandardError; end
