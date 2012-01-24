require 'spec_helper'

describe "Staff::ProjectMemberships" do
  
  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user
    login(@user)

    @project = Project.make!
  end

  describe "GET /staff/project_membership/new" do
    it 'should be able to create a new project membership for a project' do
      visit new_staff_project_membership_path(:project_id => @project.id)

      page.should have_content('New Project Membership')

      select(@person.name, :from => 'project_membership_person_id')
      check 'project_membership_is_lead'

      click_button 'Save'

      project_membership = ProjectMembership.last
      project_membership.person.should eq(@person)
      project_membership.project.should eq(@project)
      project_membership.is_lead.should eq(true)
    end

    it 'can assign a role to a project membership' do
      person = Person.make!

      visit new_staff_project_membership_path(:project_id => @project.id)

      select(person.name, :from => 'project_membership_person_id')
      uncheck 'project_membership_is_lead'
      fill_in 'project_membership_role', :with => 'Developer'

      click_button 'Save'

      project_membership = ProjectMembership.last
      project_membership.person.should eq(person)
      project_membership.project.should eq(@project)
      project_membership.is_lead.should eq(false)
      project_membership.role.should eq('Developer')
    end

    it 'can edit a project membership from the project edit screen' do

    end

    it 'can remove a project membership from the project edit screen' do

    end
  end
end
