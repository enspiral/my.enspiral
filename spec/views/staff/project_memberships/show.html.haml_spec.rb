require 'spec_helper'

describe "staff/project_memberships/show.html.haml" do
  before(:each) do
    @project_membership = assign(:project_person, stub_model(ProjectMembership))
  end

  it "renders attributes in <p>" do
    render
  end
end
