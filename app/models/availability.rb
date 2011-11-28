class Availability < ActiveRecord::Base
  belongs_to :person

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  scope :upcoming, lambda { where(["week >= ? and week <= ?", Date.today.beginning_of_week,  Date.today.beginning_of_week + 4.weeks]) }

  def week=(date)
    if date.is_a?(String)
      date = Date.strptime(date)
    end
    write_attribute(:week, date.beginning_of_week)
  end
end
