require 'spec_helper'

describe ProjectMembershipsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Enspiral::CompanyNet::Person.make :user => @user
    @person.save!

    @project = Enspiral::CompanyNet::Project.make!

    @project_membership = ProjectMembership.make! :person => @person, :project => @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  it 'lets someone join a project' do
    @project = Enspiral::CompanyNet::Project.make!
    post :create, project_id: @project.id
    response.should be_redirect
    @project.reload
    @project.people.should include(@person)
  end

  describe "DELETE destroy" do
    it "destroys the requested project_membership" do
      expect {
        delete :destroy, :id => @project_membership.id
      }.to change(ProjectMembership, :count).by(-1)
      response.should redirect_to(enspiral_company_net_projects_path)
    end
  end

end
