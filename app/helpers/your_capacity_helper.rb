module YourCapacityHelper
  def week_dates(start_on, finish_on)
    ProjectBooking.week_dates(start_on, finish_on)
  end
end
