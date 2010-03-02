class Service < ActiveRecord::Base
  has_attached_file :image, :styles => {
    :thumb => "64x64#",
    :medium  => "512x512>"
  }
  
  has_and_belongs_to_many :projects
  
end
