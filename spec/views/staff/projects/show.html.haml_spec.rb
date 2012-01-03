require 'spec_helper'

describe "staff/projects/show.html.haml" do
  before(:each) do
    @person = Person.make!
    @project = assign(:project, Project.make!)
    assign(:formatted_dates, ProjectBooking.get_formatted_dates(nil))
    assign(:project_bookings, {@person.id => {Date.today => 20, Date.today + 1.week => 12}})
    
  end

  it "renders attributes in <p>" do
    render
  end
end
