require 'spec_helper'

describe Staff::ProjectsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make!

    log_in @user
    controller.stub(:current_person) { @person }
  end


  describe "GET index" do
    it "assigns all projects as @projects" do
      get :index
      assigns(:all_projects).should eq([@project])
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      get :show, :id => @project.id
      assigns(:project).should eq(@project)
    end

    it 'assigns date variables for traversing backwards and forwards through project bookings' do
      get :show, :id => @project.id
      
      assigns(:formatted_dates)[0].should eq('This Week')
      assigns(:formatted_dates)[1].should eq('Next Week')
      assigns(:formatted_dates)[2].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))

      assigns(:current_weeks)[0].should eq(Date.today.beginning_of_week)
      assigns(:current_weeks)[4].should eq((Date.today + 4.weeks).beginning_of_week)
      
      assigns(:next_weeks)[0].should eq((Date.today + 1.weeks).beginning_of_week)
      assigns(:next_weeks)[4].should eq((Date.today + 5.weeks).beginning_of_week)
      
      assigns(:previous_weeks)[0].should eq((Date.today - 1.weeks).beginning_of_week)
      assigns(:previous_weeks)[4].should eq((Date.today + 3.weeks).beginning_of_week)
    end

    it 'shows the project bookings when dates are given as a parameter' do
      get :show, :id => @project.id, :dates => [Date.today + 1.week, Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks]

      assigns(:formatted_dates)[0].should eq('Next Week')
      assigns(:formatted_dates)[1].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[2].should eq((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[3].should eq((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[4].should eq((Date.today + 5.weeks).beginning_of_week.strftime('%b %-d'))


      assigns(:current_weeks)[0].should eq((Date.today + 1.weeks).beginning_of_week)
      assigns(:current_weeks)[4].should eq((Date.today + 5.weeks).beginning_of_week)
      
      assigns(:next_weeks)[0].should eq((Date.today + 2.weeks).beginning_of_week)
      assigns(:next_weeks)[4].should eq((Date.today + 6.weeks).beginning_of_week)
      
      assigns(:previous_weeks)[0].should eq((Date.today).beginning_of_week)
      assigns(:previous_weeks)[4].should eq((Date.today + 4.weeks).beginning_of_week)
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
    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, :project => @project.attributes
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, :project => @project.attributes
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end

      it "redirects to the created project" do
        post :create, :project => @project.attributes
        response.should redirect_to(staff_project_path(assigns(:project)))
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

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project" do
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Project.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @project.id, :project => {'these' => 'params'}
      end

      it "assigns the requested project as @project" do
        put :update, :id => @project.id, :project => @project.attributes
        assigns(:project).should eq(@project)
      end

      it "redirects to the project" do
        put :update, :id => @project.id, :project => @project.attributes
        response.should redirect_to(staff_project_path(assigns(:project)))
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => @project.id, :project => {}
        assigns(:project).should eq(@project)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => @project.id, :project => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project" do
      expect {
        delete :destroy, :id => @project.id
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      delete :destroy, :id => @project.id
      response.should redirect_to(staff_projects_url)
    end
  end

end
