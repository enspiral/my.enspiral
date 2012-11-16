# CRAIGTODO: Polymorphic resource items for this will need to be
# migrated to include the fully namespaced name of that resource.
# Do this after all the resources are in their own namespaces.
class FeaturedItem < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  scope :twitters, where('twitter_only = ?', true)
  scope :not_social, where('twitter_only = ? AND resource_type != ?', false, 'Blog')
end
