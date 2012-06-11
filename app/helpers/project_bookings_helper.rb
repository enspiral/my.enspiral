module ProjectBookingsHelper
  def time_booked_by_week(bookings, weeks)
    weeks_time = {}

    weeks.each { |week| weeks_time[week] = 0 }

    bookings.each do |booking|
      if weeks_time[booking.week]
        weeks_time[booking.week] += booking.time
      else
        # not included in range
      end
    end

    weeks_time
  end
end
