class PeopleController < ApplicationController
  layout :set_layout
  
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
  
  # dashboard
  def dashboard
	  @person = Person.find(params[:id])
  end
  
  def update_profile
    @person = current_person
    
    if request.put?
      country = params[:country].blank? ? Country.find_by_id(params[:person][:country_id]) : Country.find_or_create_by_name(params[:country])
      
      if country.blank?
        params[:person].merge! :country_id => nil, :city_id => nil
      else
        city = params[:city].blank? ? country.cities.find_by_id(params[:person][:city_id]) : country.cities.find_or_create_by_name(params[:city])
        params[:person].merge! :country_id => country.id, :city_id => (city.blank? ? nil : city.id)
      end
      
      if @person.update_attributes(params[:person])
        if current_user.admin?
          redirect_to admin_dashboard_url
        else
          redirect_to staff_dashboard_url
        end
        return
      end
    end
  end
  
  def get_cities
    country = Country.find params[:id]
    options_text = country.cities.inject("<option value=''></option>") { |opts, city| "#{opts}<option value='#{city.id}'>#{city.name}</option>"}
    render :text => options_text
  end
  
  private
  
  def set_layout
    current_user.role
  end
  
end
