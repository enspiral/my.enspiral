class Marketing::CompaniesController < MarketingController
  before_filter :require_staff
  def index
    @title = "Companies"
    @companies = Company.where("image_uid IS NOT NULL")
  end

  def show
    @company = Company.find_by_slug(params[:id])
    @title = "Companies | #{@company.name}"
  end
end
