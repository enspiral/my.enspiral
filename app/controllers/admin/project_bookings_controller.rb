class Admin::ProjectBookingsController < Admin::Base

  def index
    @peoples_capacity = ProjectBooking.get_peoples_total_booked_hours_by_week(params[:dates])

    @formatted_dates = ProjectBooking.get_formatted_dates(params[:dates])
    @current_weeks = ProjectBooking.sanatize_weeks(params[:dates])
    @next_weeks = ProjectBooking.next_weeks(@current_weeks)
    @previous_weeks = ProjectBooking.previous_weeks(@current_weeks)

    respond_to do |format|
      format.html
      format.csv  { render 'capacity_report', :layout => false }
    end
  end
end
