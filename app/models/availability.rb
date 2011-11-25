class Availability < ActiveRecord::Base
  belongs_to :person

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true
end
