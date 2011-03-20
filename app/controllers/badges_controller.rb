class BadgesController < ApplicationController
  
  def index
    @badges = Badge.order("created_at desc")
  end
  
  def new
    @badge = Badge.new
  end


end
