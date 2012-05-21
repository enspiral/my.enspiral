class Marketing::CompaniesController < MarketingController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find_by_slug(params[:id])
  end
end
