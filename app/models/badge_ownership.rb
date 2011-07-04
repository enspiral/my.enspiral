class BadgeOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
  belongs_to :person

  validates_presence_of :reason, :person, :user, :badge
end
