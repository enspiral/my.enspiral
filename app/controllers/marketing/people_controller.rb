class Marketing::PeopleController < MarketingController
  before_filter :require_staff
  def index
    @title = "People"
    @people = Enspiral::CompanyNet::Person.active.published.where("image_uid IS NOT NULL").shuffle
  end

  def show
    if params[:id]
      @person = Enspiral::CompanyNet::Person.find_by_slug(params[:id])
      @projects = @person.projects.published
      @title = "People | #{@person.name}"
      render '/marketing/people/show'
    else
      @title = "People"
      @people = Enspiral::CompanyNet::Person.active
      render '/marketing/people/index'
    end
  end
end
