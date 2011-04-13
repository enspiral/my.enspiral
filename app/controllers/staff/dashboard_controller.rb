class Staff::DashboardController < Staff::Base

  def index
    @latest_badge = BadgeOwnership.last
    @person = current_person
    render :layout => 'application'
  end

end
