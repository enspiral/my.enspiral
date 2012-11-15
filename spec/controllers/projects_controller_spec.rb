require 'spec_helper'

describe ProjectsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @company = Enspiral::CompanyNet::Company.make!
    @customer = Customer.make!(company: @company)
    @company.people << @person

    @project = Project.make! :name => Faker::Company.name, :customer => @customer
    @company.projects << @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns all projects as @projects" do
      get :index, company_id: @company.id
      assigns(:all_projects).should eq([@project])
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      get :show, :id => @project.id
      assigns(:project).should eq(@project)
    end

  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new
      assigns(:project).should be_a_new(Project)
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      get :edit, :id => @project.id
      assigns(:project).should eq(@project)
    end
  end

  describe "POST create" do
    before :each do 
      @new_project = Project.make(company:@company)
      @new_project.customer = Customer.make!
    end
    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, :project => @new_project.attributes
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, :project => @new_project.attributes
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end

      it "redirects to the created project" do
        post :create, :project => @new_project.attributes
        response.should redirect_to(project_path(assigns(:project)))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        assigns(:project).should be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        response.should render_template("new")
      end
    end
  end
end
