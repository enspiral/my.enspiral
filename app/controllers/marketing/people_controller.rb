class Marketing::PeopleController < MarketingController
  def index
    @people = Person.where(active: true)
  end

  def show
    if params[:id]
      @person = Person.find_by_slug(params[:id])
      @projects = @person.projects.published
      render '/marketing/people/show'
    else
      @people = Person.active
      render '/marketing/people/index'
    end
  end
end
