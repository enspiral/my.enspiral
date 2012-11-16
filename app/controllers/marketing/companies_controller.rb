class Marketing::CompaniesController < MarketingController
  
  def index
    @companies = Company.visible.with_image.where(kind: params[:kind])

    case params[:kind]
    when :services
      render 'marketing/companies/services'
    when :startups
      render 'marketing/companies/startups'
    else
      render 'marketing/companies/index'
    end
  end

  def show
    @company = Company.find_by_slug(params[:id])
    @people = @company.people
    @show_projects = false
    @show_projects = true if !@company.projects.blank? and @company.show_projects == true
    @title = "Companies | #{@company.name}"
  end
end
