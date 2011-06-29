class Badge < ActiveRecord::Base
  has_many :badge_ownerships, :dependent => :destroy
  has_many :users, :through => :badge_ownerships

  validates :name, :presence => true
  validates :image, :presence => true

  mount_uploader :image, BadgeUploader
end
