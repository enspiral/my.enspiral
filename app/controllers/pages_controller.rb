class PagesController < ApplicationController

  layout 'pages'
  
  def holding
  end

  def about
  end

  def recruitment
  end

  def index
    @feeds = FeedEntry.latest
  end

  def services
  end
  
  def contact
    @phone_number = '04 123 1234'
  end

  def social_media
  end
  
end
