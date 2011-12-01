class Availability < ActiveRecord::Base
  belongs_to :person

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  scope :upcoming, lambda { where(["week >= ? and week <= ?", Date.today.beginning_of_week,  Date.today.beginning_of_week + 4.weeks]) }

  def week=(date)
    # If the date is a string, transform it into a date
    if !date.nil? and date.is_a?(String)
      date = Date.strptime(date)
    end
    if date.is_a?(Date)
      # Change the date to the beginning of the week
      write_attribute(:week, date.beginning_of_week)
    else
      # Try write the invalid object to throw the validates error
      write_attribute(:week, date)
    end
  end
end
