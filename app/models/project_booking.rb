class ProjectBooking < ActiveRecord::Base
  belongs_to :project_membership

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  validates_presence_of :project_membership
  validates_uniqueness_of :project_membership_id, :scope => :week
  validate :week_is_monday

  def week_is_monday
    #week is a date
    errors.add(:week, 'is not a monday') unless week.at_beginning_of_week == week
  end

  def self.week_dates(start_date, end_date)
    dates = []
    date = start_date
    dates << date
    while true do
      date += 1.week
      if date <= end_date
        dates << date
      else
        break
      end
    end
    dates
  end

  def self.total_hours_per_week(start_on, end_on)
    weeks_with_hours = {}
    dates = week_dates(start_on, end_on).each { |week| weeks_with_hours[week] = 0 }
    
    self.where(week: start_on..end_on).each do |booking|
      booking.time = 0 if booking.time.nil?
      if weeks_with_hours[booking.week]
        weeks_with_hours[booking.week] += booking.time
      else
        # not included in range
        raise "booking week not in list: #{booking.week.inspect}, list: #{dates.inspect}, hash: #{weeks_with_hours.inspect}"
      end
    end

    weeks_with_hours
  end

  #def self.total_hours_per_week(bookings, start_on, end_on)
    #week_dates = weeks_array(start_on, end_on)
    #weeks_with_hours = {}
    #week_dates.each { |week| weeks_with_hours[week] = 0 }

    #bookings.where(week: start_on..end_on).each do |booking|
      #if weeks_with_hours[booking.week]
        #weeks_with_hours[booking.week] += booking.time
      #else
        ## not included in range
        #raise "booking week not in list: #{booking.week.inspect}, list: #{week_dates.inspect}, hash: #{weeks_with_hours.inspect}"
      #end
    #end

    #weeks_with_hours
  #end
end
