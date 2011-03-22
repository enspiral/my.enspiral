require 'spec_helper'

describe "badge_ownerships/index.html.haml" do

  before(:each) do
    BadgeOwnership.make!
    @badge_ownerships = BadgeOwnership.all

    render
  end
  subject{rendered}
  it{should have_selector(".badge .badge-name", :content => "Name".to_s)}
  it{should have_selector(".badge .reason")}
  it{should have_selector(".badge .small_img")}
  it{should have_selector(".badge .user")}
  it{should render_template(:layout => "application")}
end
