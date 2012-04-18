require 'spec_helper'

describe ProjectMembershipsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make

    @project_membership = ProjectMembership.make! :person => @person, :project => @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET new" do
    it "assigns a new project_membership as @project_membership" do
      get :new, :project_id => @project.id
      assigns(:project_membership).should be_a_new(ProjectMembership)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Staff::ProjectMembership" do
        expect {
          post :create, 
            :project_membership => ProjectMembership.
              make(:project => Project.make!, 
                   :person => Person.make!).attributes
        }.to change(ProjectMembership, :count).by(1)
      end

      it "assigns a newly created project_membership as @project_membership" do
        post :create, 
          :project_membership => ProjectMembership.
            make(:project => Project.make!, 
                 :person => Person.make!).attributes
        assigns(:project_membership).should be_a(ProjectMembership)
        assigns(:project_membership).should be_persisted
      end

      it "redirects to the created project_membership" do
        project = Project.make!
        post :create, :project_membership => ProjectMembership.make(:project => project, :person => Person.make!).attributes
        response.should redirect_to(edit_project_path(project.id))
      end

      it "creates a project_membership given a project_id and using the controllers logged in person reference" do
        expect {
         post :create, :project_id => Project.make!.id
        }.to change(ProjectMembership, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project_membership as @project_membership" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectMembership.any_instance.stub(:save).and_return(false)
        post :create, :project_membership => {}
        assigns(:project_membership).should be_a_new(ProjectMembership)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectMembership.any_instance.stub(:save).and_return(false)
        post :create, :project_membership => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project_memberships" do
        project = Project.make!
        project_membership_1 = ProjectMembership.make! :project => project
        project_membership_2 = ProjectMembership.make! :project => project

        project_membership_1.is_lead = true
        project_membership_2.is_lead = false
        
        put :update, :project_id => project.id, :project_membership => { 
          project_membership_1.id.to_s => project_membership_1.attributes,
          project_membership_2.id.to_s => project_membership_2.attributes} 

        ProjectMembership.find(project_membership_1.id).is_lead.should eq(true)
        ProjectMembership.find(project_membership_2.id).is_lead.should eq(false)
      end
 
      it "redirects to the project_membership" do
        put :update, :project_id => @project.id, :project_membership => {@project_membership.id.to_s => @project_membership.attributes}
        response.should redirect_to(edit_project_path(@project.id))
      end
    end

    describe "with invalid params" do
      it "assigns the project_membership as @project_membership" do
        # Trigger the behavior that occurs when invalid params are submitted
        project_membership = ProjectMembership.make! :project => @project
        project_membership.person_id = 4224
        put :update, :project_id => @project.id, :project_membership => {project_membership.id.to_s => project_membership.attributes}
        assigns(:project).should eq(@project)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        project_membership = ProjectMembership.make! :project => @project
        project_membership.person_id = 4224
        put :update, :project_id => @project.id, :project_membership => {project_membership.id.to_s => project_membership.attributes}
        response.should render_template('projects/edit')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project_membership" do
      expect {
        delete :destroy, :id => @project_membership.id
      }.to change(ProjectMembership, :count).by(-1)
    end

    it "destroys the requested project_membership given a project_id" do
      expect {
        delete :destroy, :project_id => @project.id
      }.to change(ProjectMembership, :count).by(-1)
    end


    it "redirects to the project_memberships list" do
      delete :destroy, :id => @project_membership.id
      response.should redirect_to(projects_path)
    end
  end

end
