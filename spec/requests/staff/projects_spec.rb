require 'spec_helper'

describe "Staff::Projects" do

  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user

    login(@user)
  end

  describe "GET /staff/projects" do

    it "should load the project management page when there are no projects" do
      visit staff_projects_path
      page.should have_content('Project Listings')
      page.should have_content('You are not currently part of any projects.')
    end

    it 'should show the user all projects, and projects that they have a membership of' do
      project1 = Project.make! 
      project2 = Project.make!
      ProjectMembership.make! :project => project2, :person => @person

      visit staff_projects_path

      page.should have_content(project1.name)
      page.should have_button('Join')
      page.should have_button('Show')
      page.should have_button('Edit')
    end
  end

  describe 'PUT /staff/projects/1' do

    it 'should load the edit page and be able to edit a project' do
      project = Project.make! 
      ProjectMembership.make! :project => project, :person => @person

      visit staff_projects_path

      click_button 'Edit'

      fill_in 'project_description', :with => 'New Desc'
      click_button 'Save'

      Project.last.description.should eq('New Desc')
    end
  end

  describe 'GET /staff/projects/1' do

    before(:each) do
      @project = Project.make!
      @project_member_1 = ProjectMembership.make! :project => @project
      @project_member_2 = ProjectMembership.make! :project => @project
      @project_booking_1 = ProjectBooking.make! :person => @project_member_1.person, :project => @project, :time => 25
      @project_booking_2 = ProjectBooking.make! :person => @project_member_2.person, :project => @project, :time => 15
    end

    it 'should show the project details' do
      
      visit staff_project_path :id => @project

      page.should have_content(@project.name)
      page.should have_content(@project.description)
      page.should have_content(@project.customer.name)
      page.should have_content(@project.status)
    end

    it 'should show the project memberships' do
      visit staff_project_path :id => @project
      
      page.should have_content(@project_member_1.person.first_name)
      page.should have_content(@project_member_1.person.last_name)
      page.should have_content(@project_member_2.person.first_name)
      page.should have_content(@project_member_1.person.last_name)
    end

    it 'should show the project members availabilities, and enable traversal through time' do
      visit staff_project_path :id => @project

      page.should have_content('This Week')
      page.should have_content(@project_booking_1.time)
      page.should have_content(@project_booking_2.time)

      click_link 'Next >>'

      page.should_not have_content('This Week')

      click_link '<< Previous'

      page.should have_content('This Week')
    end

  end


end
