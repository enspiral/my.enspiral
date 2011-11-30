require 'spec_helper'

describe "staff/bookings/index.html.haml" do
  before(:each) do
    assign(:bookings, [
      stub_model(Booking),
      stub_model(Booking)
    ])
  end

  it "renders a list of staff/bookings" do
    render
  end
end
