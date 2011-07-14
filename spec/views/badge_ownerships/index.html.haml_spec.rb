require 'spec_helper'

describe "badge_ownerships/index.html.haml" do
  before(:each) do
    badge = Badge.make
    badge_ownership = BadgeOwnership.make!(:badge => badge)
  
    assign(:badge_ownerships, [ badge_ownership ])
    controller.stub(:current_user).and_return(User.make(:admin))
    render
  end

  subject{rendered}

  it{should have_selector(".badge")}
  it{should render_template(:partial => "badge_ownerships/_badge")}
end
