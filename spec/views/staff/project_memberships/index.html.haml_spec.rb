require 'spec_helper'

describe "staff/project_memberships/index.html.haml" do
  before(:each) do
    assign(:project_memberships, [
      ProjectMembership.make!,
      ProjectMembership.make!
    ])
  end

  it "renders a list of staff/project_memberships" do
    render
  end
end
