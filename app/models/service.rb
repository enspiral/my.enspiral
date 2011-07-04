class Service < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :service_category
  
  validates_presence_of :person, :service_category, :description, :rate
  
  validates_uniqueness_of :service_category_id, :scope => :person_id
  
  validates_numericality_of :rate, :greater_than => 0
  
  def self.search options = {}
    conditions = []
    conditions << 'service_category_id = ?' unless options[:service_category_id].blank?
    conditions << 'upper(description) like ?' unless options[:description].blank?
    conditions_array = []
    unless conditions.blank?
      conditions_array << conditions.join(' and ')
      conditions_array << options[:service_category_id] unless options[:service_category_id].blank?
      conditions_array << "%#{options[:description].upcase}%" unless options[:description].blank?
    end
    
    if conditions_array.blank?
      self.order('rate desc')
    else
      self.where(*conditions_array).order('rate desc')
    end
  end
  
end
