class Marketing::PeopleController < MarketingController
  def index
    @people = Person.where(active: true)
  end

  def show
    if params[:id]
      @person = Person.find(params[:id])
      render '/marketing/people/show'
    else
      @people = Person.active
      render '/marketing/people/index'
    end
  end
end
