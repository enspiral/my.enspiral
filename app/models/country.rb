class Country < ActiveRecord::Base
  
  has_many :cities, :order => 'name'
  has_many :people
  
  validates_presence_of :name
  
  validates_uniqueness_of :name
  
end
