require 'spec_helper'

describe "staff/project_people/index.html.haml" do
  before(:each) do
    assign(:staff_project_people, [
      stub_model(Staff::ProjectPerson),
      stub_model(Staff::ProjectPerson)
    ])
  end

  it "renders a list of staff/project_people" do
    render
  end
end
