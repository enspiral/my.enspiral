require 'spec_helper'

describe "staff/project_people/show.html.haml" do
  before(:each) do
    @staff_project_person = assign(:staff_project_person, stub_model(Staff::ProjectPerson))
  end

  it "renders attributes in <p>" do
    render
  end
end
