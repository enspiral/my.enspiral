class Marketing::CompaniesController < MarketingController
  before_filter :require_staff
  def index
    @title = "Companies"
    @companies = Company.all
  end

  def show
    @company = Company.find_by_slug(params[:id])
    @people = @company.people
    @show_projects = false
    @show_projects = true if !@company.projects.blank? and @company.show_projects == true
    @title = "Companies | #{@company.name}"
  end
end
