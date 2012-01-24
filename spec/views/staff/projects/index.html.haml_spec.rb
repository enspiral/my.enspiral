require 'spec_helper'

describe "staff/projects/index.html.haml" do
  before(:each) do
    Project.make!
    Project.make!

    view.stub!(:sort_column).and_return('name')
    view.stub!(:sort_direction).and_return('asc')
    assign(:current_projects, [
      stub_model(Project),
      stub_model(Project) 
    ])
    assign(:all_projects, 
      Project.where_status('active').paginate(:per_page => 10, :page => 1) 
    )

  end

  it "renders a list of projects" do
    render
  end
end
