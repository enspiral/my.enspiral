class Marketing::ProjectsController < MarketingController
  def index
    @projects = Project.published
  end

  def show
    @project = Project.find_by_slug(params[:id])
    render layout: false
  end
end
