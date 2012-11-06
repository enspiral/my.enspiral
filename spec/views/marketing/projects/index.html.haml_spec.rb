require 'spec_helper'

describe "marketing/projects/index.html.haml" do
  before(:each) do
    @projects = [Project.make!]
  end
  it "should render with empty project images" do
    @projects.first.stub(:projects_images).and_return([])
    assign(:projects, @projects)
    render
  end
  it "should render with project_images that have no uid" do
    project_image = mock_model(ProjectsImage)
    project_image.stub(:image).and_return(nil)
    @projects.first.stub(:projects_images).and_return([project_image])
    assign(:projects, @projects)
    render
  end
end
