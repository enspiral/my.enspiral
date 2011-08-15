class Goal < ActiveRecord::Base
  belongs_to :person
  validates_presence_of :title, :date
  validates :score, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
end
