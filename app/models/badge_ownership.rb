class BadgeOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge

  validates :reason, :presence => true
end
