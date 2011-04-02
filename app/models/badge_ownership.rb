class BadgeOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
  belongs_to :person

  validates :reason, :presence => true
  validates :person, :presence => true
  validates :user, :presence => true
end
