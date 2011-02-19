class Staff::DashboardController < Staff::Base

  def index
    @person = current_person
    render :layout => 'application'
  end

end
