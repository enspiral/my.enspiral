require 'spec_helper'

describe "staff/project_memberships/new.html.haml" do
  before(:each) do
    project_membership = ProjectMembership.make!
    assign(:project_membership, project_membership)
    assign(:project, project_membership.project)
  end

  it "renders new staff_project_membership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_project_memberships_path, :method => "post" do
    end
  end
end
