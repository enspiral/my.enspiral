class Marketing::ProjectsController < MarketingController
  before_filter :require_staff
  def index
    @title = "Projects"
    @projects = Enspiral::CompanyNet::Project.published
  end

  def show
    @project = Enspiral::CompanyNet::Project.find_by_slug(params[:id])
    render layout: false
  end
end
