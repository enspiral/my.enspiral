class ProfilesController < IntranetController
  def roladex
    @people = Person.order("first_name asc")
  end
  
  def edit
    @person = current_person
  end

  def show
    @person = Person.find_by_id(params[:id])

    @dates = []
    for i in (0..8)
      @dates.push((Date.today + i.weeks).beginning_of_week.to_s)
    end
    @project_bookings = ProjectBooking.get_persons_projects_bookings(@person, @dates)
    @default_time_available = current_person.default_hours_available
    @project_bookings_totals = ProjectBooking.get_persons_total_booked_hours_by_week(@person, @dates)

    @formatted_dates = ProjectBooking.get_formatted_dates(@dates)

  end

  def update
    @person = current_person
    
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

    if @person.update_attributes(params[:person])
      flash[:success] = 'Profile Updated'
      redirect_to accounts_path
    else
      render :edit
    end
  end
end
