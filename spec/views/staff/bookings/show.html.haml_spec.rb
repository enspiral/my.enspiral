require 'spec_helper'

describe "staff/bookings/show.html.haml" do
  before(:each) do
    @staff_booking = assign(:booking, stub_model(Booking))
  end

  it "renders attributes in <p>" do
    render
  end
end
