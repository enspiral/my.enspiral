class ProjectBookingsController < IntranetController

  def index
    @project_bookings = ProjectBooking.get_persons_projects_bookings(current_person, params[:dates])
    @default_time_available = current_person.default_hours_available
    @project_bookings_totals = ProjectBooking.get_persons_total_booked_hours_by_week(current_person, params[:dates])

    @formatted_dates = ProjectBooking.get_formatted_dates(params[:dates])
    @current_weeks = ProjectBooking.sanatize_weeks(params[:dates])
    @next_weeks = ProjectBooking.next_weeks(@current_weeks)
    @previous_weeks = ProjectBooking.previous_weeks(@current_weeks)

    @person = current_person

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_bookings }
    end
  end

  def edit
    @person = params[:person_id] ? Person.find(params[:person_id]) : current_user.person
    @project = Project.find(params[:project_id])
    @project_membership = ProjectMembership.find_by_project_id_and_person_id(@project.id, @person.id)
    if !@project_membership
      flash[:notice] = "No such Project Membership Exists for #{@person.name} in #{@project.name}."
      redirect_to projects_path
    end
    if current_person.company_admin_or_admin?(@project.company) or @project.project_memberships.where(is_lead: true).collect{|p| p.person == current_person}.include?(true) or @person == current_person
      @project_bookings = ProjectBooking.get_persons_project_bookings(@project_membership, params[:dates])
      @formatted_dates = ProjectBooking.get_formatted_dates(params[:dates])
    else
      flash[:notice] = "Not today captiain! You must be project lead, or admin to edit someone else's capacity."
      redirect_to projects_path
    end
  end

  # PUT /capacity/update
  def update 
    @project_membership = ProjectMembership.find(params[:project_membership_id])

    for pb in params[:project_bookings]
      project_booking = ProjectBooking.find_or_create_by_project_membership_id_and_week(@project_membership.id, pb[:week])
      project_booking.time = pb[:time]
      project_booking.save
    end

    respond_to do |format|
      flash[:notice] = 'Details successfully updated.'
      redirect_path = @project_membership.person.id != current_user.person.id ? project_url(@project_membership.project.id) : capacity_url
      format.html { redirect_to redirect_path}
      format.json { head :ok }
    end
  end
end
