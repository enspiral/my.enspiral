class Staff::DashboardController < Staff::Base

  def index
    @latest_badge = BadgeOwnership.last
    puts @latest_badge.inspect
    @person = current_person
    render :layout => 'application'
  end

end
