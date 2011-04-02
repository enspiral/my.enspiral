require 'spec_helper'

describe "badge_ownerships/index.html.haml" do
  before(:each) do
    assign(:badge_ownerships, [
      BadgeOwnership.make,
      BadgeOwnership.make,
    ])

    render
  end

  subject{rendered}
  it{should have_selector(".badge .badge-name")}
  it{should have_selector(".badge .reason")}
  it{should have_selector(".badge .small_img")}
  it{should have_selector(".badge .user")}
  it{should render_template(:layout => "application")}
end
