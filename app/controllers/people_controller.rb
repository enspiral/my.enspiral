class PeopleController < ApplicationController  
  before_filter :require_user

  # GET /people
  # GET /people.xml
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
    @projects = @person.projects
  end

  def edit
    @person = current_person
  end

  #Active user only assumes staff because admin is handled in admin/people_controller.rb
  def update
    @person = current_person
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Your details were successfully updated.'
      redirect_to staff_dashboard_path
    else
      render :action => "edit"
    end
  end

  # dashboard
  def dashboard
	  @person = Person.find(params[:id])
  end

  def check_gravatar_once
    @person = @person = Person.find(params[:id])
    @person.update_gravatar_status(@person.email)
    if @person.has_gravatar?
      render :json => {
        :status => "found_gravatar",
        :message => "Congratulations, you win - I was wrong."
        }
    else
      render :json => {
        :status => "no_gravatar",
        :message => "Still no joy sorry. <a href='#{check_gravatar_once_person_path(current_user.person)}' id ='check-gravatar-again' class='button'>Try again</a>"
      }
    end
  end
  
end
