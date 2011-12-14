class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :customer
  has_many :project_memberships
  has_many :people, :through => :project_memberships

  validates_presence_of :status, :name
  validates_inclusion_of :status, :in => STATUSES

  mount_uploader :image, ProjectUploader
end
