class FeaturedItem < ActiveRecord::Base
  has_one :resource, polymorphic: true
end
