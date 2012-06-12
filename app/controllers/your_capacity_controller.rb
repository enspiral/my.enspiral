class YourCapacityController < IntranetController
  before_filter :person

  def index
    @default_time_available = current_person.default_hours_available
  end

  def edit
  end

  def update
    for pb_params in params[:project_bookings]
      pb = @person.project_bookings.
            find_or_create_by_project_membership_id_and_week(
              pb_params[:project_membership_id], pb_params[:week])
      pb.update_attribute(:time, pb_params[:time])
    end
    redirect_to your_capacity_index_path, notice: 'Capacity details updated'
  end

  protected

  def person
    @person = current_person
  end

end
