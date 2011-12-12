require 'spec_helper'

describe "staff/project_memberships/new.html.haml" do
  before(:each) do
    assign(:project_membership, stub_model(ProjectMembership).as_new_record)
  end

  it "renders new staff_project_membership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_project_memberships_path, :method => "post" do
    end
  end
end
