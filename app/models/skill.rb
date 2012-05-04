class Skill < ActiveRecord::Base
  
  has_many :people_skills, dependent: :delete_all
  has_many :people, :through => :people_skills
  
  validates :description, :presence => true
end
