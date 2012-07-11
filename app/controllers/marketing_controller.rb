class MarketingController < ApplicationController
  def index
    @featured_items = FeaturedItem.not_social.order('created_at DESC')
    @twitters = FeaturedItem.twitters
    @blogs = FeaturedItem.where(resource_type: 'Blog')
    @social_items = @twitters + @blogs
  end

  def about
    render 'marketing/static_pages/about'
  end
end
