require 'spec_helper'

describe "staff/project_people/edit.html.haml" do
  before(:each) do
    @staff_project_person = assign(:staff_project_person, stub_model(Staff::ProjectPerson))
  end

  it "renders the edit staff_project_person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_project_people_path(@staff_project_person), :method => "post" do
    end
  end
end
