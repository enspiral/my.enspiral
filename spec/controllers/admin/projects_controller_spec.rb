require 'spec_helper'

describe Admin::ProjectsController do

  before(:each) do
    @user = User.make(:admin)
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make! :name => 'AA'

    log_in @user
    controller.stub(:current_person) { @person }
  end


  describe "GET index" do
    it "assigns all projects as @projects" do
      get :index
      assigns(:projects).should eq([@project])
    end

    it 'reorders the list when the column and direct parameters are given' do
      project = Project.make! :name => 'AB'
      project2 = Project.make! :name => 'AC'


      get :index
      assigns(:projects).should eq([@project, project, project2])

      get :index, :sort => 'name', :direction => 'desc'
      assigns(:projects).should eq([project2, project, @project])
    end
  end

  describe "DELETE destroy" do
    it "destroys a given project record" do
      project = Project.make!
      expect {
        post :destroy, :id => project.id
      }.to change(Project, :count).by(-1)
    end

    it "destroys all project memberships and project bookings" do
      project = Project.make!
      ProjectMembership.make! :project => project

      expect {
        post :destroy, :id => project.id
      }.to change(ProjectMembership, :count).by(-1)
    end
  end
end
