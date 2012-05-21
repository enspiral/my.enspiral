class MarketingController < ApplicationController
  def index
    @featured_items = FeaturedItem.all
  end
end
