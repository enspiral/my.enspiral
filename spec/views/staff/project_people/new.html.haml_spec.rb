require 'spec_helper'

describe "staff/project_people/new.html.haml" do
  before(:each) do
    assign(:project_person, stub_model(ProjectPerson).as_new_record)
  end

  it "renders new staff_project_person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_project_people_path, :method => "post" do
    end
  end
end
