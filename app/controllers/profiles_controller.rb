class ProfilesController < IntranetController
  helper_method :total_hours_per_week
  helper_method :weeks_array
  def roladex
    @people = Enspiral::CompanyNet::Person.order("first_name asc")
  end
  
  def edit
    if params[:id]
      @person = Enspiral::CompanyNet::Person.find(params[:id])
    else
      @person = current_person
    end
  end

  def show
    if params[:id]
      @person = Enspiral::CompanyNet::Person.find(params[:id])
    else
      @person = current_person
    end

    @start_on = Date.today.at_beginning_of_week
    @end_on = @start_on + 8.weeks

    @project_bookings = @person.project_bookings.where(week: @start_on..@end_on)
    @hours_per_week = @project_bookings.total_hours_per_week(@start_on, @end_on)
    @week_dates = ProjectBooking.week_dates(@start_on, @end_on)
  end

  def update
    puts "***********************"
    @person = Enspiral::CompanyNet::Person.find(params[:id])
    
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
      @person.user.update_attributes(:email => params[:person][:email])
      flash[:success] = 'Profile Updated'
      redirect_to ({action: :show})
    else
      render :edit
    end
  end

end
