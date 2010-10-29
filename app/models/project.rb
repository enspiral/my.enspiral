class Project < ActiveRecord::Base
  has_many :worked_on, :dependent => :destroy
  has_many :people, :through => :worked_on

  has_attached_file :image, :styles => {
    :thumb => "64x64#",
    :medium  => "512x512>"
  }
  
end
