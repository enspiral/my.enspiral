class ProjectMembership < ActiveRecord::Base
  belongs_to :person, class_name: 'Enspiral::CompanyNet::Person'
  belongs_to :project, class_name: 'Enspiral::CompanyNet::Project'
  has_many :project_bookings

  validates_presence_of :person
  validates_uniqueness_of :project_id, :scope => :person_id
end
