require 'spec_helper'

describe "staff/project_people/index.html.haml" do
  before(:each) do
    assign(:project_people, [
      ProjectPerson.make!,
      ProjectPerson.make!
    ])
  end

  it "renders a list of staff/project_people" do
    render
  end
end
