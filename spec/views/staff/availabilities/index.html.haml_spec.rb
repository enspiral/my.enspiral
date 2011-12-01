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
  end
end
