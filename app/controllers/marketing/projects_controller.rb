class Marketing::ProjectsController < MarketingController
  before_filter :require_staff
  def index
    @title = "Projects"
    @projects = Project.published.with_image
  end

  def show
    @project = Project.find_by_slug(params[:id])
    render layout: false
  end
end
