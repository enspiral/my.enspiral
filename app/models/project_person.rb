class ProjectPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :project

  validates_presence_of :person, :project
end
