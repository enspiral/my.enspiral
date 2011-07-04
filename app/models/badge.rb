class Badge < ActiveRecord::Base
  has_many :badge_ownerships, :dependent => :destroy
  has_many :users, :through => :badge_ownerships

  validates_presence_of :name, :image

  mount_uploader :image, BadgeUploader
end
