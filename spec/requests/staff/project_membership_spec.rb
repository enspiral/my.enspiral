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
  end
end
