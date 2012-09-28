class Metric < ActiveRecord::Base
  belongs_to :company
  attr_accessible :active_users, :for_date, :people, :revenue
  validates_uniqueness_of :for_date
end
