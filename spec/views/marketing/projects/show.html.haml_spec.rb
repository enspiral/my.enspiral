require 'spec_helper'

describe "marketing/projects/show.html.haml" do
  before(:each) do
    @project = Enspiral::CompanyNet::Project.make!
  end
  it "should render with empty images" do
    @project.stub(:projects_images).and_return([])
    assign(:project, @project)
    render
  end

  it "should render with project_images that have no uid" do
    project_image = mock_model(ProjectsImage)
    project_image.stub(:image).and_return(nil)
    @project.stub(:projects_images).and_return([project_image])
    assign(:project, @project)
    render
  end

  it "should render with project_images that have no uid for images in second spot" do
    project_image = mock_model(ProjectsImage)
    project_image.stub(:image).and_return(nil)
    project_image2 = mock_model(ProjectsImage)
    project_image2.stub(:image).and_return(nil)
    @project.stub(:projects_images).and_return([project_image, project_image2])
    assign(:project, @project)
    render
  end

end
