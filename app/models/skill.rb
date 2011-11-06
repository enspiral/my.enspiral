class Skill < ActiveRecord::Base
  
  has_many :people_skills
  has_many :people, :through => :people_skills
  
  validates :description, :presence => true
end
