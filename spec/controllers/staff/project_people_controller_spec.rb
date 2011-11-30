require 'spec_helper'

describe Staff::ProjectPeopleController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make

    @project_person = ProjectPerson.make! :person => @person, :project => @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns all staff_project_people as @staff_project_people" do
      get :index
      assigns(:project_people).should eq([@project_person])
    end
  end

  describe "GET show" do
    it "assigns the requested staff_project_person as @staff_project_person" do
      get :show, :id => @project_person.id
      assigns(:project_person).should eq(@project_person)
    end
  end

  describe "GET new" do
    it "assigns a new staff_project_person as @staff_project_person" do
      get :new
      assigns(:project_person).should be_a_new(ProjectPerson)
    end
  end

  describe "GET edit" do
    it "assigns the requested staff_project_person as @staff_project_person" do
      get :edit, :id => @project_person.id
      assigns(:project_person).should eq(@project_person)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Staff::ProjectPerson" do
        expect {
          post :create, :project_person => @project_person.attributes
        }.to change(ProjectPerson, :count).by(1)
      end

      it "assigns a newly created staff_project_person as @staff_project_person" do
        post :create, :project_person => @project_person.attributes
        assigns(:project_person).should be_a(ProjectPerson)
        assigns(:project_person).should be_persisted
      end

      it "redirects to the created staff_project_person" do
        post :create, :project_person => @project_person.attributes
        response.should redirect_to(staff_projects_path)
      end

      it "creates a project_person given a project_id and using the controllers person reference" do
        expect {
         post :create, :project_id => Project.make!.id
        }.to change(ProjectPerson, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved staff_project_person as @staff_project_person" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectPerson.any_instance.stub(:save).and_return(false)
        post :create, :project_person => {}
        assigns(:project_person).should be_a_new(ProjectPerson)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectPerson.any_instance.stub(:save).and_return(false)
        post :create, :project_person => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested staff_project_person" do
        # Assuming there are no other staff_project_people in the database, this
        # specifies that the Staff::ProjectPerson created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProjectPerson.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @project_person.id, :project_person => {'these' => 'params'}
      end

      it "assigns the requested staff_project_person as @staff_project_person" do
        put :update, :id => @project_person.id, :project_person => @project_person.attributes
        assigns(:project_person).should eq(@project_person)
      end

      it "redirects to the staff_project_person" do
        put :update, :id => @project_person.id, :project_person => @project_person.attributes
        response.should redirect_to(staff_project_person_path(@project_person))
      end
    end

    describe "with invalid params" do
      it "assigns the staff_project_person as @staff_project_person" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectPerson.any_instance.stub(:save).and_return(false)
        put :update, :id => @project_person.id, :project_person => {}
        assigns(:project_person).should eq(@project_person)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectPerson.any_instance.stub(:save).and_return(false)
        put :update, :id => @project_person.id, :project_person => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested staff_project_person" do
      expect {
        delete :destroy, :id => @project_person.id
      }.to change(ProjectPerson, :count).by(-1)
    end

    it "destroys the requested staff_project_person given a project_id" do
      expect {
        delete :destroy, :project_id => @project.id
      }.to change(ProjectPerson, :count).by(-1)
    end


    it "redirects to the staff_project_people list" do
      delete :destroy, :id => @project_person.id
      response.should redirect_to(staff_projects_path)
    end
  end

end
