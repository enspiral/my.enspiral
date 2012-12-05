class PeopleSkill < ActiveRecord::Base
  belongs_to :person
  belongs_to :skill, class_name: 'Enspiral::CompanyNet::Person'
end
