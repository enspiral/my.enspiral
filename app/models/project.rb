class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :customer
  has_many :project_people
  has_many :people, :through => :project_people
  has_many :bookings

  validates_presence_of :status, :name
  validates_inclusion_of :status, :in => STATUSES

  after_update :save_project_people

  def project_people_attributes=(project_people_attributes)
    project_people_attributes.each do |attributes|
      project_people.build(attributes)
    end
  end

  def existing_project_people_attributes=(project_people_attributes)
    project_people.reject(&:new_record?).each do |project_person|
      attributes = project_people_attributes[project_person.id.to_s]
      if attributes
        project_person.attributes = attributes
      else
        project_people.delete(project_person)
      end
    end
  end

  def save_project_people
    project_people.each do |project_person|
      project_person.save!
    end
  end

  mount_uploader :image, ProjectUploader
end
