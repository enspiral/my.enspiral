class MarketingController < ApplicationController
  def index
    @featured_items = FeaturedItem.not_social.order('created_at DESC')
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "enspiral" && password == "absonderlich"
      end
    end

end
