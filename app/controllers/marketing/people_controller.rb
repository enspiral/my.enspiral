class Marketing::PeopleController < MarketingController
  def index
    @title = "People"
    @people = Person.active.published.where("image_uid IS NOT NULL").shuffle
  end

  def show
    redirect_to action: :index and return
    if params[:id]
      @person = Person.find_by_slug(params[:id])
      @person_projects = @person.projects.published
      @title = "People | #{@person.name}"
      render '/marketing/people/show'
    else
      @title = "People"
      @people = Person.active
      render '/marketing/people/index'
    end
  end
end
