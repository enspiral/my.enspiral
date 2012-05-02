class Admin::ProjectBookingsController < AdminController

  def index
    @dates = []
    for i in (0..8)
      @dates.push((Date.today + i.weeks).beginning_of_week.to_s)
    end
    @peoples_capacity = ProjectBooking.get_peoples_total_booked_hours_by_week(@dates)

    @formatted_dates = ProjectBooking.get_formatted_dates(@dates)

    @current_weeks = ProjectBooking.sanatize_weeks(params[:dates])
    @next_weeks = ProjectBooking.next_weeks(@current_weeks)
    @previous_weeks = ProjectBooking.previous_weeks(@current_weeks)

    respond_to do |format|
      format.html
      format.csv  { render 'capacity_report', :layout => false }
    end
  end

  def person
    @person = Person.find params[:id]
    @project_bookings = ProjectBooking.get_persons_projects_bookings(@person, params[:dates])
    @default_time_available = current_person.default_hours_available
    @project_bookings_totals = ProjectBooking.get_persons_total_booked_hours_by_week(@person, params[:dates])

    @formatted_dates = ProjectBooking.get_formatted_dates(params[:dates])
    @current_weeks = ProjectBooking.sanatize_weeks(params[:dates])
    @next_weeks = ProjectBooking.next_weeks(@current_weeks)
    @previous_weeks = ProjectBooking.previous_weeks(@current_weeks)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_bookings }
    end
  end
end
