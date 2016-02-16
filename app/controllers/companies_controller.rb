class CompaniesController < IntranetController

  before_filter :load_company, only: [:show, :xero_import_single, :xero_import_dashboard]

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
  end

  def xero_import_single
    @invoice = import_invoice(params[:xero_ref], params[:xero_id])

    if @invoice
      redirect_to controller: 'companies', action: 'xero_import_dashboard', id: @company.id, imported_invoice_id: @invoice.id
    else
      redirect_to xero_import_dashboard_company_path(@company)
    end
  end

  private

  def load_company
    @company = Company.find(params[:id])
  end

  def import_invoice(xero_ref, xero_id)
    begin
      raise ArgumentError unless xero_ref.present? || xero_id.present?
      if xero_ref
        @invoice = @company.import_xero_invoice_by_reference(xero_ref)
      else
        @invoice = @company.import_xero_invoice(xero_id)
      end
      flash[:notice] = "Invoice successfully created! #{view_context.link_to("View here", company_invoice_path(@company))}."
    rescue => e
      flash[:error] = error_message e
      return nil
    end
    @invoice
  end

  def error_message(error)
    return "That invoice doesn't seem to exist in Xero" if error.is_a? Xeroizer::InvoiceNotFoundError
    return "That invoice couldn't be saved" if error.is_a? ActiveRecord::RecordInvalid
    return "Xero Reference and ID are blank" if error.is_a? ArgumentError
    "I can't determine the error - please contact the developer"
  end
end
