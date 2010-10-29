class Service < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :service_category
  
  validates_presence_of :person_id, :service_category_id, :description, :rate
  
  validates_uniqueness_of :service_category_id, :scope => :person_id
  
  validates_numericality_of :rate, :greater_than => 0
  
end
