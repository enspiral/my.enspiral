require 'spec_helper'

describe "staff/projects/edit.html.haml" do
  before(:each) do
    @project = assign(:project, Project.make!)
    @project_memberships = assign(:project_memberships, [ProjectMembership.make!(:project => @project)])
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_projects_path(@project), :method => "post" do
    end
  end
end
