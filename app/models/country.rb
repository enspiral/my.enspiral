class Country < ActiveRecord::Base
  
  has_many :cities
  
  validates_presence_of :name
  
  validates_uniqueness_of :name
  
end
