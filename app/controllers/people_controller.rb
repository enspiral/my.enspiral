class PeopleController < ApplicationController  
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
    @projects = @person.projects
  end
  
  # dashboard
  def dashboard
	  @person = Person.find(params[:id])
  end
  
end
