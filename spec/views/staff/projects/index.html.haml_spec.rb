require 'spec_helper'

describe "staff/projects/index.html.haml" do
  before(:each) do
    assign(:projects, [
      stub_model(Project),
      stub_model(Project) 
    ])
  end

  it "renders a list of projects" do
    render
  end
end
