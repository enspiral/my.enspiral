class Staff::ProjectBookingsController < Staff::Base

  #GET /capacity
  def index

    @project_bookings = ProjectBooking.get_persons_projects_bookings(current_person, params[:dates])
    @default_time_available = current_person.default_hours_available
    @project_bookings_sum = ProjectBooking.get_persons_total_booked_hours(current_person, params[:dates])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_bookings }
    end
  end

  # GET /capacity/edit
  def edit
    @project_bookings = ProjectBooking.get_persons_project_bookings(current_person, params[:project_id], params[:dates])
    @project = Project.find(params[:project_id])
  end

  # PUT /capacity/update
  def update 
    success = true
    for pb in params[:project_bookings]
      project_booking = ProjectBooking.find_or_create_by_person_id_and_project_id_and_week(current_person.id, pb[:project_id], pb[:week])
      project_booking.time = pb[:time]
      success = success && project_booking.save
    end

    respond_to do |format|
      format.html { redirect_to staff_capacity_url }
      format.json { head :ok }
    end
  end
end
