require 'spec_helper'

describe "projects/edit.html.haml" do
  before(:each) do
    @project = assign(:project, stub_model(Project))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
    end
  end
end
