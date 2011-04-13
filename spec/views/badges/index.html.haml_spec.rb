require 'spec_helper'

describe "badges/index.html.haml" do
  before(:each) do
    assign(:badges, [
      stub_model(Badge,
        :name => "Name"
      ),
      stub_model(Badge,
        :name => "Name"
      )
    ])
    controller.stub(:current_user).and_return(User.make(:admin))
    render
  end
  subject{rendered}
  it{should render_template(:partial => "badges/_badge")}
  it{should have_selector(".badge .badge-name", :content => "Name".to_s, :count => 2)}
end
