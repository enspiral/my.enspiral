require 'spec_helper'

describe "staff/bookings/edit.html.haml" do
  before(:each) do
    @staff_booking = assign(:booking, stub_model(Booking))
  end

  it "renders the edit staff_booking form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_bookings_path(@staff_booking), :method => "post" do
    end
  end
end
