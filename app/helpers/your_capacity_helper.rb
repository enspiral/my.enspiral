module YourCapacityHelper
  def week_dates
    ProjectBooking.week_dates(@start_on, @finish_on)
  end
end
