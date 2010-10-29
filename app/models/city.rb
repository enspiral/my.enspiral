class City < ActiveRecord::Base
  
  belongs_to :country
  
  validates_presence_of :country_id, :name
  
  validates_uniqueness_of :name, :scope => :country_id
  
end
