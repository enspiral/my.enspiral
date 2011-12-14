require 'spec_helper'

describe "staff/availabilities/index.html.haml" do
  before(:each) do
    assign(:availabilities, [ Availability.make, Availability.make ])
    assign(:projects, [ Project.make, Project.make ])

  end

  it "renders a list of availabilities" do
    render
  end
end
