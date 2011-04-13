class Badge < ActiveRecord::Base
  has_many :badge_ownerships
  has_many :users, :through => :badge_ownerships

  validates :name, :presence => true
  validates :image_file_name, :presence => true

  has_attached_file :image, :styles => {
    :thumb => "64x64#",
  }
 
end
