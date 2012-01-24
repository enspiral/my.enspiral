require 'spec_helper'

describe "staff/project_bookings/index.html.haml" do
  before(:each) do
    project = Project.make!

    assign(:formatted_dates, ProjectBooking.get_formatted_dates(nil))
    assign(:project_bookings, {project.id => {Date.today => 20, Date.today + 1.week => 12}})
    assign(:person, Person.make!(:default_hours_available => 40))
    assign(:project_bookings_totals, {Date.today => 12, (Date.today + 1.week) => 14})
  end

  it "renders a list of project_bookings" do
    render
  end
end
