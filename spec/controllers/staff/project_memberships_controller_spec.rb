require 'spec_helper'

describe Staff::ProjectMembershipsController do

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

  describe "GET index" do
    it "assigns all staff_project_memberships as @project_memberships" do
      get :index
      assigns(:project_memberships).should eq([@project_membership])
    end
  end

  describe "GET show" do
    it "assigns the requested staff_project_membership as @project_membership" do
      get :show, :id => @project_membership.id
      assigns(:project_membership).should eq(@project_membership)
    end
  end

  describe "GET new" do
    it "assigns a new staff_project_membership as @project_membership" do
      get :new
      assigns(:project_membership).should be_a_new(ProjectMembership)
    end
  end

  describe "GET edit" do
    it "assigns the requested staff_project_membership as @project_membership" do
      get :edit, :id => @project_membership.id
      assigns(:project_membership).should eq(@project_membership)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Staff::ProjectMembership" do
        expect {
          post :create, :project_membership => @project_membership.attributes
        }.to change(ProjectMembership, :count).by(1)
      end

      it "assigns a newly created staff_project_membership as @project_membership" do
        post :create, :project_membership => @project_membership.attributes
        assigns(:project_membership).should be_a(ProjectMembership)
        assigns(:project_membership).should be_persisted
      end

      it "redirects to the created staff_project_membership" do
        post :create, :project_membership => @project_membership.attributes
        response.should redirect_to(staff_projects_path)
      end

      it "creates a project_membership given a project_id and using the controllers person reference" do
        expect {
         post :create, :project_id => Project.make!.id
        }.to change(ProjectMembership, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved staff_project_membership as @project_membership" do
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
      it "updates the requested staff_project_membership" do
        # Assuming there are no other staff_project_memberships in the database, this
        # specifies that the Staff::ProjectMembership created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProjectMembership.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @project_membership.id, :project_membership => {'these' => 'params'}
      end

      it "assigns the requested staff_project_membership as @project_membership" do
        put :update, :id => @project_membership.id, :project_membership => @project_membership.attributes
        assigns(:project_membership).should eq(@project_membership)
      end

      it "redirects to the staff_project_membership" do
        put :update, :id => @project_membership.id, :project_membership => @project_membership.attributes
        response.should redirect_to(staff_project_membership_path(@project_membership))
      end
    end

    describe "with invalid params" do
      it "assigns the staff_project_membership as @project_membership" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectMembership.any_instance.stub(:save).and_return(false)
        put :update, :id => @project_membership.id, :project_membership => {}
        assigns(:project_membership).should eq(@project_membership)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectMembership.any_instance.stub(:save).and_return(false)
        put :update, :id => @project_membership.id, :project_membership => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested staff_project_membership" do
      expect {
        delete :destroy, :id => @project_membership.id
      }.to change(ProjectMembership, :count).by(-1)
    end

    it "destroys the requested staff_project_membership given a project_id" do
      expect {
        delete :destroy, :project_id => @project.id
      }.to change(ProjectMembership, :count).by(-1)
    end


    it "redirects to the staff_project_memberships list" do
      delete :destroy, :id => @project_membership.id
      response.should redirect_to(staff_projects_path)
    end
  end

end
