class CompaniesController < IntranetController
  def edit
    @company = Company.find(params[:id])
    unless current_person.admin? or current_person.company_adminships.map{|ca| ca.company_id}.include?(@company.id)
      flash[:error] = "Not for you sunshine"
      redirect_to admin_companies_url
    end
  end
end
