class FeaturedItem < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  scope :twitters, where('twitter_only = ?', true)
  scope :not_social, where('twitter_only = ? AND resource_type != ?', false, 'Blog')
end
