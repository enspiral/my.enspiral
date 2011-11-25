require 'spec_helper'

describe "availabilities/index.html.haml" do
  before(:each) do
    assign(:availabilities, [
      stub_model(Availability,
        :person => nil,
        :time => 1
      ),
      stub_model(Availability,
        :person => nil,
        :time => 1
      )
    ])
  end

  it "renders a list of availabilities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
