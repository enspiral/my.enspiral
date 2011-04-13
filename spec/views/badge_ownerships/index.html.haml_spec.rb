require 'spec_helper'

describe "badge_ownerships/index.html.haml" do
  before(:each) do
    assign(:badge_ownerships, [
      BadgeOwnership.make!,
    ])
    controller.stub(:current_user).and_return(User.make(:admin))
    render
  end

  subject{rendered}
  it{should have_selector(".badge .badge-name")}
  it{should have_selector(".badge-reason")}
  it{should have_selector(".badge-image")}
  it{should render_template(:partial => "badge_ownerships/_badge")}
end
