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
end
