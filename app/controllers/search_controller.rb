class SearchController < IntranetController
  def index
    @people = Enspiral::CompanyNet::Person.search(params[:big_search], star: true, with: {active: true}).compact

    @admin_of_ids = current_person.company_adminships.map{|ca| ca.company_id}
    if current_user.admin?
      @invoices = Invoice.search(params[:big_search], star: true, order: :id, sort_mode: :desc).compact
    elsif !current_person.company_adminships.blank?
      @invoices = Invoice.search(params[:big_search], star: true,
                                 :with => {company_id: @admin_of_ids},
                                 order: :id, sort_mode: :desc
                                ).compact
    else
      @invoices = nil
    end
    if current_user.admin?
      @projects = Enspiral::CompanyNet::Project.search(params[:big_search], star: true).compact
    elsif !current_person.company_adminships.blank?
      @projects = Enspiral::CompanyNet::Project.search(params[:big_search], star: true,
                                 :with => {
                                   company_id: @admin_of_ids
                                 }
                              ).compact
    else
      @projects = Enspiral::CompanyNet::Project.search(params[:big_search], star: true,
                                 :with => {
                                   company_id: current_person.company_ids
                                 }
                              ).compact
    end
  end
end
