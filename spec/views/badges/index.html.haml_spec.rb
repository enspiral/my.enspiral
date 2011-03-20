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

    render
  end
  subject{rendered}
  it{should have_selector(".badge .badge-name", :content => "Name".to_s, :count => 2)}
  it{should render_template(:layout => "application")}
end
