class Marketing::CompaniesController < MarketingController
  before_filter :require_staff
  def index
    @title = "Companies"
    @companies = Company.all
  end

  def show
    @company = Company.find_by_slug(params[:id])
    @people = @company.people
    @title = "Companies | #{@company.name}"
  end
end
