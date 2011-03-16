class PeopleController < ApplicationController  
  before_filter :authenticate_user!, :except => :show

  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
    @projects = @person.projects
  end

  def edit
    @person = Person.find(params[:id])
    redirect_to edit_person_path(current_person) unless @person == current_person || admin_user?
  end

  #Active user only assumes staff because admin is handled in admin/people_controller.rb
  def update
    @person = admin_user? ? Person.find(params[:id]) : current_person
    if request.put?
      country = params[:country].blank? ? Country.find_by_id(params[:person][:country_id]) : Country.find_or_create_by_name(params[:country])
      
      if country.blank?
        params[:person].merge! :country_id => nil, :city_id => nil
      else
        city = params[:city].blank? ? country.cities.find_by_id(params[:person][:city_id]) : country.cities.find_or_create_by_name(params[:city])
        params[:person].merge! :country_id => country.id, :city_id => (city.blank? ? nil : city.id)
      end
      
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Details successfully updated.'
        if current_user.admin?
          redirect_to people_path
        else
          redirect_to staff_dashboard_url
        end
        return
      end
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
  
  def get_cities
    country = Country.find params[:id]
    options_text = country.cities.inject("<option value=''></option>") { |opts, city| "#{opts}<option value='#{city.id}'>#{city.name}</option>"}
    render :text => options_text
  end
end
