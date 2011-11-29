require 'spec_helper'

describe "staff/project_people/index.html.haml" do
  before(:each) do
    assign(:project_people, [
      stub_model(ProjectPerson),
      stub_model(ProjectPerson)
    ])
  end

  it "renders a list of staff/project_people" do
    render
  end
end
