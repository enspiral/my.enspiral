require 'spec_helper'

describe "staff/project_bookings/index.html.haml" do
  before(:each) do
    assign(:project_bookings, [ ProjectBooking.make, ProjectBooking.make ])
  end

  it "renders a list of project_bookings" do
    render
  end
end
