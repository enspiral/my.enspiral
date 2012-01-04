require 'spec_helper'

describe "staff/project_bookings/edit.html.haml" do
  before(:each) do
    @project = Project.make!
    @project_membership = ProjectMembership.make! :project => @project
    @project_Booking = assign(:project_bookings, [ProjectBooking.make!(:project_membership => @project_membership), 
                              ProjectBooking.make!(:project_membership => @project_membership)])
    @project = assign(:project, @project)
    assign(:formatted_dates, ProjectBooking.get_formatted_dates(nil))
  end

  it "renders the edit project_booking form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_capacity_update_path(@project_Booking), :method => "post" do
      #assert_select "input#project_booking_person", :name => "project_booking[person]"
      #assert_select "input#project_booking_time", :name => "project_booking[time]"
    end
  end
end
