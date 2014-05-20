class SearchController < IntranetController
  def index
    @admin_of_ids = current_person.company_adminships.map{|ca| ca.company_id}
    @people = Person.where("first_name ilike ? or last_name ilike ? or email ilike ?", "%#{params[:big_search]}%", "%#{params[:big_search]}%", "%#{params[:big_search]}%")
    
    @projects = Project.where("name ilike ? or description ilike ? or slug ilike ?", "%#{params[:big_search]}%", "%#{params[:big_search]}%", "%#{params[:big_search]}%")
    
    @accounts = Account.where("name ilike ? or description ilike ?", "%#{params[:big_search]}%", "%#{params[:big_search]}%")

    customer_ids = Customer.where("name ilike ?", "%#{params[:big_search]}%").map(&:id)
    @invoice_customers = Invoice.where("customer_id in (?)", customer_ids)
    @invoice_amounts = Invoice.where(:amount => params[:big_search].to_i) if Integer(params[:big_search]) rescue nil
    @invoice_xeros = Invoice.where("xero_reference like ?", "%#{params[:big_search]}%")
    @invoice_amounts = [] if @invoice_amounts.nil?
    @invoice_customers = [] if @invoice_customers.nil?
    @invoice_xeros = [] if @invoice_xeros.nil?
    @invoices = @invoice_customers.concat(@invoice_amounts).concat(@invoice_xeros)

    # @people = Person.search(params[:big_search], star: true, with: {active: true}).compact

    # @admin_of_ids = current_person.company_adminships.map{|ca| ca.company_id}
    # if current_user.admin?
    #   @invoices = Invoice.search(params[:big_search], star: true, order: :id, sort_mode: :desc).compact
    # elsif !current_person.company_adminships.blank?
    #   @invoices = Invoice.search(params[:big_search], star: true,
    #                              :with => {company_id: @admin_of_ids},
    #                              order: :id, sort_mode: :desc
    #                             ).compact
    # else
    #   @invoices = nil
    # end
    # if current_user.admin?
    #   @projects = Project.search(params[:big_search], star: true).compact
    # elsif !current_person.company_adminships.blank?
    #   @projects = Project.search(params[:big_search], star: true,
    #                              :with => {
    #                                company_id: @admin_of_ids
    #                              }
    #                           ).compact
    # else
    #   @projects = Project.search(params[:big_search], star: true,
    #                              :with => {
    #                                company_id: current_person.company_ids
    #                              }
    #                           ).compact
    # end
  end
end
