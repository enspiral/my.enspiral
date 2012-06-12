require 'spec_helper'

describe YourCapacityController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make!
    @project_membership = ProjectMembership.make! :person => @person, :project => @project

    log_in @user
  end

  describe "GET index" do
    it 'index' do
      get :index, project_id: @project.id
      response.should be_success
    end
    it 'edit' do
      get :edit, project_id: @project.id
      response.should be_success
    end

    it 'update creates project_bookings' do
      lambda{
        put :update, project_bookings: [{project_membership_id: @project_membership.id,
                                       week: Date.today.at_beginning_of_week, time: 5}]
      }.should change(ProjectBooking, :count).by(1)
      response.should be_redirect
      ProjectBooking.last.project_membership.project.should == @project
    end

    it 'update updates project_bookings' do
      lambda{
        put :update, project_bookings: [{project_membership_id: pb.project_membership_id,
                                       week: pb.week, time: 5}]
      }.should_not change(ProjectBooking, :count)
      response.should be_redirect
    end

  end
end

