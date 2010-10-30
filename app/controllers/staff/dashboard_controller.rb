class Staff::DashboardController < Staff::Base

  def index
    render :layout => 'application'
  end

end
