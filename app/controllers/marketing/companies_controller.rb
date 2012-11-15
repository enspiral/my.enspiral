class Marketing::CompaniesController < MarketingController
  before_filter :require_staff
  def index
    @title = "Companies"
    @companies = Enspiral::CompanyNet::Company.all
  end

  def show
    @company = Enspiral::CompanyNet::Company.find_by_slug(params[:id])
    @title = "Companies | #{@company.name}"
  end
end
