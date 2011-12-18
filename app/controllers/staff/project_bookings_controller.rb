class Staff::ProjectBookingsController < Staff::Base

  #GET /capacity
  def index

    @project_bookings = ProjectBooking.get_persons_project_bookings(current_person, params[:dates])
    @default_time_available = current_person.default_hours_available
    @project_bookings_sum = ProjectBooking.get_persons_total_booked_hours(current_person, params[:dates])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_bookings }
    end
  end

  # GET /capacity/edit
  def edit
    @project_bookings = current_person.project_bookings
  end

  # PUT /capacity/update
  def update 
    for av in params[:project_bookings]
      project_booking = ProjectBooking.find(av[:id])
      project_booking.update_attributes({:time => av[:time]})
    end

    respond_to do |format|
      format.html { redirect_to staff_capacity_url }
      format.json { head :ok }
    end
  end
end
