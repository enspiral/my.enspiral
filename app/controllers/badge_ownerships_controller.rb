class BadgeOwnershipsController < ApplicationController

  def index
    @badge_ownerships = BadgeOwnership.order("created_at desc")
  end

  def new
    @badge_ownership = BadgeOwnership.new
  end
end
