class Marketing::CompaniesController < MarketingController
  def index
    @title = "Companies"
    @companies = Company.all
  end

  def show
    @title = "Companies | #{@company.name}"
    @company = Company.find_by_slug(params[:id])
  end
end
