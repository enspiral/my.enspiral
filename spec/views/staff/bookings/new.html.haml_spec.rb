require 'spec_helper'

describe "staff/bookings/new.html.haml" do
  before(:each) do
    assign(:booking, stub_model(Booking).as_new_record)
  end

  it "renders new staff_booking form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_bookings_path, :method => "post" do
    end
  end
end
