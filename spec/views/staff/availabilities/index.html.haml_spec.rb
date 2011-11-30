require 'spec_helper'

describe "staff/availabilities/index.html.haml" do
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
    assign(:total_hours_booked, [
      stub_model(Booking),
      stub_model(Booking)
    ])
    assign(:projects, [
      stub_model(Project),
      stub_model(Project)
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
