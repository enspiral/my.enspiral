require 'xero_errors'
require 'loggers/import_logger'

class CompaniesController < IntranetController
  include XeroErrors
  include Loggers

  before_filter :load_company, only: [:show, :xero_import_single, :xero_import_dashboard, :xero_invoice_manual_check]

  def index
    @companies = Company.all
  end
  def edit
    @company = current_person.admin_companies.find(params[:id])
    unless current_person.admin? or current_person.company_adminships.map{|ca| ca.company_id}.include?(@company.id)
      flash[:error] = "Not for you sunshine!"
      redirect_to admin_companies_url
    end
  end

  def show
  end

  def update
    @company = current_person.admin_companies.find(params[:id])
    
    if params[:country].blank?
      country = Country.find_by_id(params[:company][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:company][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:company].merge! :country_id => country.id
      params[:company].merge! :city_id => city.id if city
    end

    if @company.update_attributes(params[:company])
      flash[:success] = 'Profile Updated'
      redirect_to company_path(@company)
    else
      render :edit
    end
  end

  def xero_import_dashboard
    invoice_id = params[:imported_invoice_id]
    @imported_invoice = Invoice.find(invoice_id) if invoice_id.present?
    @import_logs = XeroImportLog.where(company_id: @company.id).order('performed_at DESC').page params[:page]
    @all_invoices = Invoice.where(company_id: @company.id)
  end

  def xero_import_single
    identifier = params[:xero_ref].present? ? params[:xero_ref] : params[:xero_id]
    begin
      @invoice = import_invoice(params[:xero_ref], params[:xero_id], params[:overwrite])
      redirect_to controller: 'companies', action: 'xero_import_dashboard', id: @company.id, imported_invoice_id: @invoice.id
    rescue => e
      flash[:notice] = nil
      flash[:error] = "#{error_message e}"
      if e.is_a? XeroErrors::InvoiceAlreadyExistsError
        redirect_to controller: 'companies', action: 'xero_invoice_manual_check', id: @company.id, xero_invoice_id: e.xero_invoice.invoice_id, enspiral_invoice_id: e.enspiral_invoice.id and return
      end
      save_import_results_to_db(1, [], {identifier => error_message(e)}, @company, current_person)
      redirect_to xero_import_dashboard_company_path(@company)
      return
    end
    save_import_results_to_db(1, [identifier], {}, @company, current_person)
  end

  def xero_invoice_manual_check
    if params[:xero_invoice_id].blank?
      flash[:error] = "Xero invoice is blank"
      redirect_to xero_import_dashboard_company_path(@company) and return
    end

    begin
      @xero_invoice = @company.find_xero_invoice(params[:xero_invoice_id])
      @enspiral_invoice = Invoice.find(params[:enspiral_invoice_id])
    rescue => e
      flash[:error] = "Cannot find invoice with id #{params[:enspiral_invoice_id]}"
      redirect_to xero_import_dashboard_company_path(@company)
      return
    end
  end

  private

  def load_company
    @company = Company.find(params[:id])
  end

  def import_invoice(xero_ref, xero_id, do_overwrite = false)
    overwrite = do_overwrite.blank? ? false : true
    raise ArgumentError if xero_ref.blank? && xero_id.blank?
    if xero_ref.present?
      @invoice = @company.import_xero_invoice(xero_ref, overwrite)
    else
      @invoice = @company.import_xero_invoice(xero_id, overwrite)
    end
    flash[:notice] = "Invoice successfully created!" if @invoice
    @invoice
  end

  def error_message(error)
    return "Issue creating invoice. Valid? #{error.enspiral_invoice.valid?} Errors: #{error.enspiral_invoice.errors.messages}" if error.is_a? XeroErrors::NoInvoiceCreatedError
    return error.message if error.is_a? XeroErrors::EnspiralInvoiceAlreadyPaidError
    return error.message if error.is_a? XeroErrors::InvoiceAlreadyExistsError
    return error.message if error.is_a? Xeroizer::InvoiceNotFoundError
    return error.message if error.is_a? XeroErrors::AmbiguousInvoiceError
    return error.message if error.is_a? XeroErrors::InvalidXeroInvoiceStatusError
    return error.message if error.is_a? XeroErrors::InvalidXeroInvoiceStatusError
    return "That invoice looks like its missing some fields (or some fields are invalid) and couldn't be saved (this a bug - contact the developer)" if error.is_a? ActiveRecord::RecordInvalid
    return "No Xero identifier given" if error.is_a? ArgumentError
    "I can't determine the error - please contact the developer (#{error.message})"
  end
end
