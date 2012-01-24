require 'spec_helper'

describe "Admin::Projects" do

  before(:each) do
    @user = User.make!(:admin)
    @person = Person.make! :user => @user

    login(@user)
  end

  describe "GET /admin/projects" do

    it 'should allow the user to get to the project admin page from the dashboard' do
      visit admin_dashboard_path
      page.should have_link('Projects')
      click_link 'Projects'

      page.should have_content('Project Administration')
    end

    it "should load the page with a direct link" do
      visit admin_projects_path
      page.should have_content('Project Administration')
    end

    it 'should show the user all projects, and projects that they have a membership of' do
      project = Project.make! 

      visit admin_projects_path

      page.should have_content(project.name)
      page.should have_button('Show')
      page.should have_button('Edit')
      page.should have_button('Delete')
    end
  end

  describe 'PUT /admin/projects/1' do

    it 'should load the edit page and be able to edit a project' do
      project = Project.make! 

      visit admin_projects_path

      click_button 'Edit'

      fill_in 'project_description', :with => 'New Desc'
      select('Inactive', :from => 'project_status')

      select('25', :from => 'project_due_date_3i')
      select('October', :from => 'project_due_date_2i')
      select('2012', :from => 'project_due_date_1i')

      click_button 'project_save_button'

      saved_project = Project.last
      saved_project.description.should eq('New Desc')
      saved_project.status.should eq('inactive')
      saved_project.due_date.should eq(Date.parse('25/10/2012'))
    end

    it 'should be able to edit the project memberships' do
      project = Project.make!
      pm = ProjectMembership.make! :project => project 

      visit admin_projects_path

      click_button 'Edit'

      check "project_membership_#{pm.id}_is_lead"
      fill_in "project_membership_#{pm.id}_role", :with => 'Project Manager'

      click_button 'project_membership_save_button'

      project_membership = ProjectMembership.find(pm.id)
      project_membership.is_lead.should eq(true)
      project_membership.role.should eq('Project Manager')

    end
  end

  describe 'GET /admin/projects/1' do

    before(:each) do
      @project = Project.make!
      @project_member_1 = ProjectMembership.make! :project => @project
      @project_member_2 = ProjectMembership.make! :project => @project
      @project_booking_1 = ProjectBooking.make! :project_membership => @project_member_1, :time => 25
      @project_booking_2 = ProjectBooking.make! :project_membership => @project_member_2, :time => 15
    end

    it 'should show the project details' do
      
      visit admin_projects_path

      click_button 'Show'

      page.should have_content(@project.name)
      page.should have_content(@project.description)
      page.should have_content(@project.customer.name)
      page.should have_content(@project.status.titleize)
    end

    it 'should show the project memberships' do
      visit admin_projects_path

      click_button 'Show'
      
      page.should have_content(@project_member_1.person.first_name)
      page.should have_content(@project_member_1.person.last_name)
      page.should have_content(@project_member_2.person.first_name)
      page.should have_content(@project_member_1.person.last_name)
    end

    it 'should show the project members availabilities, and enable traversal through time' do
      visit admin_projects_path

      click_button 'Show'

      page.should have_content('This Week')
      page.should have_content(@project_booking_1.time)
      page.should have_content(@project_booking_2.time)

      click_link 'Next >>'

      page.should_not have_content('This Week')

      click_link '<< Previous'

      page.should have_content('This Week')
    end
  end

  describe 'GET /staff/projects/new' do
    it 'should enable the user to create a new project' do
      new_project = Project.make
      new_project.description = 'A new project for testing'

      visit admin_projects_path
      click_link '+ New Project'

      page.should have_content('New Project')
      fill_in('project_name', :with => new_project.name)
      fill_in('project_description',:with => new_project.description)
      select(new_project.customer.name, :from => 'project_customer_id')
      select('Active', :from => 'project_status')

      select('25', :from => 'project_due_date_3i')
      select('October', :from => 'project_due_date_2i')
      select('2012', :from => 'project_due_date_1i')

 
      click_button 'Save'
      saved_project = Project.last
      saved_project.name.should eq(new_project.name)
      saved_project.description.should eq(new_project.description)
      saved_project.customer.should eq(new_project.customer)
      saved_project.status.should eq(new_project.status)
      saved_project.due_date.should eq(Date.parse('25/10/2012'))

    end
  end
end
