class Project < ActiveRecord::Base
  has_many :people

  has_attached_file :image, :styles => {
    :thumb => "64x64#",
    :medium  => "512x512>"
  }
  
end
