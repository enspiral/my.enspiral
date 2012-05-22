class Marketing::ProjectsController < MarketingController
  def index
    @projects = Project.published
  end

  def show
  end
end
