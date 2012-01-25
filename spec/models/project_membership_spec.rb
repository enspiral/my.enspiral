require 'spec_helper'

describe ProjectMembership do

 before(:each) do
    @project_membership = ProjectMembership.make!
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}
  it {should have_many(:project_bookings)}

  it 'should be able to assign a role' do
    @project_membership.role = 'developer'
    @project_membership.save!

    @project_membership.should have(0).errors
  end

  it 'should be able to have a project_lead' do
    @project_membership.is_lead = true
    @project_membership.save!

    @project_membership.should have(0).errors
  end

  it 'should be unique based of the person_id project_id combination' do
    @duplicate = ProjectMembership.make :project => @project_membership.project, :person => @project_membership.person
    @duplicate.should_not be_valid
  end
end
