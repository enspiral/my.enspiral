require 'spec_helper'

describe "staff/project_memberships/edit.html.haml" do
  before(:each) do
    @project_membership = assign(:project_membership, stub_model(ProjectMembership))
  end

  it "renders the edit project_membership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_project_memberships_path(@project_membership), :method => "post" do
    end
  end
end
