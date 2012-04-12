class PeopleController < ApplicationController  
  layout :resolve_layout
  before_filter :authenticate_user!, :except => [:show, :list]
  before_filter :require_admin, :only => [:deactivate, :activate]

  def index
    @people = Person.active.order("first_name asc")
  end

  def list
    @people = Person.active.order("first_name asc")
  end
  
  def inactive 
    @people = Person.where(:active => false).order("first_name asc")
    render :action => 'index'
  end

  def show
    @person = Person.find(params[:id])
    @badges = BadgeOwnership.where(:user_id => @person.user.id)
    @projects = @person.projects
  end

  def deactivate
    @person = Person.find(params[:id])
    @person.deactivate
    flash[:notice] = "Deactivated Person (#{@person.name})"
    redirect_to people_path
  end

  def activate
    @person = Person.find(params[:id])
    @person.activate
    flash[:notice] = "Activated Person (#{@person.name})"
    redirect_to people_path
  end

  def edit
    @person = Person.find(params[:id])
    redirect_to edit_person_path(current_person) unless @person == current_person || admin_user?
  end

  def update
    @person = Person.find(params[:id])
     
    if (@person != current_person) && !admin_user?
      redirect_to staff_dashboard_url, :error => "You are not authorized to edit this persons profile." and return
    end

    if params[:country].blank?
      country = Country.find_by_id(params[:person][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:person][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:person].merge! :country_id => country.id
      params[:person].merge! :city_id => city.id if city
    end

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Details successfully updated.'
        format.html do 
          if current_user.admin?
            redirect_to people_url
          else
            redirect_to staff_dashboard_url
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # dashboard
  def dashboard
	  @person = Person.find(params[:id])
  end

  def log_lead
  end

  def thank_you
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

  private 
    def resolve_layout
      case action_name
      when 'show', 'list'
        'application'
      else
        'intranet'
      end
    end
end
