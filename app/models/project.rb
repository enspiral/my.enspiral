class Project < ActiveRecord::Base
  has_many :people

  mount_uploader :image, ProjectUploader
end
