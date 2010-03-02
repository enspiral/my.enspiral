class Service < ActiveRecord::Base
  has_attached_file :image, :styles => {
    :thumb => "64x64#",
    :medium  => "512x512>"
  }
end
