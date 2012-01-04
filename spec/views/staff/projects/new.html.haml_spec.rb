require 'spec_helper'

describe "staff/projects/new.html.haml" do
  before(:each) do
    assign(:project, Project.make!)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_projects_path, :method => "post" do
    end
  end
end
