require 'spec_helper'
require 'xero_errors'

describe CompaniesController do
  include XeroErrors

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

  describe 'import stuff' do

    before do
      Company.stub(:find) { @company }
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
          @company.stub(:find_xero_invoice) { raise ArgumentError.new }
        end

        it 'reports an error' do
          get :xero_import_single, id: @company.id
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /No Xero identifier given/
        end
      end

      context "when the invoice doesn't exist in xero" do

        before do
          @company.stub(:find_xero_invoice) { raise Xeroizer::InvoiceNotFoundError.new }
        end

        it 'reports an error' do
          get :xero_import_single, id: @company.id, xero_ref: "INV-1234"
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /doesn't seem to exist in Xero/
        end

        it 'should log the error' do
          lambda{
            get :xero_import_single, id: @company.id, xero_ref: "INV-1234"
          }.should change(XeroImportLog, :count).from(0).to(1)

          log = XeroImportLog.last
          expect(log.person).to eq @person
          expect(log.company).to eq @company
          expect(log.number_of_invoices).to eq 1
          expect(log.invoices_with_errors).to eq({"INV-1234" => "Invoice INV-1234 doesn't seem to exist in Xero"})

        end
      end

      context 'when there is an error saving the new invoice' do
        before do
          @company.stub(:import_xero_invoice_by_reference) { raise ActiveRecord::RecordInvalid.new(double.as_null_object) }
        end

        it 'reports an error' do
          get :xero_import_single, id: @company.id, xero_ref: "1000"
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /couldn't be saved/
        end
      end

      context 'when the existing db invoice is already paid' do
        before do
          @company.stub(:import_xero_invoice_by_reference) { raise XeroErrors::EnspiralInvoiceAlreadyPaidError.new("invoice is already paid") }
        end

        it 'reports an error' do
          get :xero_import_single, id: @company.id, xero_ref: "1000"
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /already paid/
        end
      end

      context 'when the existing db invoice already exists' do

        let!(:fake_inv)   { Invoice.make!(company: @company) }
        let!(:xero_inv)   { FakeXeroInvoice.new }

        context 'when the user confirms overwrite of the invoice' do
          before do
            @company.stub(:import_xero_invoice_by_reference) { fake_inv }
          end

          it 'reports an error' do
            get :xero_import_single, id: @company.id, xero_ref: "1000", overwrite: "true"
            response.should redirect_to(action: :xero_import_dashboard,
                                        id: assigns(:company).id,
                                        imported_invoice_id: fake_inv.id)
            assigns(:invoice).should_not be_nil
            flash[:notice].should match /successfully/
          end
        end

        context 'when the user has not confirmed overwrite' do
          before do
            @company.stub(:import_xero_invoice_by_reference) { raise XeroErrors::InvoiceAlreadyExistsError.new("please check manually", fake_inv, xero_inv) }
          end

          it 'reports an error' do
            get :xero_import_single, id: @company.id, xero_ref: "1000"
            response.should redirect_to(action: :xero_invoice_manual_check,
                                        id: assigns(:company).id,
                                        enspiral_invoice_id: fake_inv.id,
                                        xero_invoice_id: xero_inv.invoice_id)
            assigns(:invoice).should be_nil
            flash[:error].should match /check manually/
          end

        end
      end

      context "if there is some other error" do
        before do
          @company.stub(:import_xero_invoice_by_reference) { raise FakeError.new("OMG!!!1") }
        end

        it 'reports an error' do
          get :xero_import_single, id: @company.id, xero_ref: "1000"
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /can't determine the error/
        end
      end

    end

    describe '#xero_invoice_manual_check' do
      let!(:invoice)      { Invoice.make!(company: @company) }

      context 'if xero ref is missing' do
        it 'reports an error' do
          get :xero_invoice_manual_check, id: @company.id, enspiral_invoice_id: invoice.id
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /Xero invoice is blank/
        end
      end

      context 'if invoice id is missing' do
        it 'reports an error' do
          get :xero_invoice_manual_check, id: @company.id, xero_invoice_id: "1000"
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /Cannot find invoice/
        end
      end

      context 'if both arguments are missing' do
        it 'reports an error' do
          get :xero_invoice_manual_check, id: @company.id
          response.should redirect_to(xero_import_dashboard_company_path(@company))
          assigns(:invoice).should be_nil
          flash[:error].should match /Xero invoice is blank/
        end
      end

      context "if both xero invoice and enspiral invoice are found" do

        it 'displays the page' do
          @company.stub(:find_xero_invoice) { FakeXeroInvoice.new }

          get :xero_invoice_manual_check, id: @company.id, xero_invoice_id: "1000", enspiral_invoice_id: invoice.id
          response.should be_success
          response.should render_template :xero_invoice_manual_check
        end
      end
    end
  end
end

