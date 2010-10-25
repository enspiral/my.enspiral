require 'spec_helper'

describe PeopleController do
  setup :activate_authlogic

  before(:each) do
    @person = Person.make!(:staff)
    login_as @person.user
    request.env["HTTP_REFERER"] = 'http://somewhere.com'
  end

  describe "editing" do
    it "successfully load" do
      get :edit
      response.should be_success
    end
    it "should load the current user" do
      get :edit
      assigns(:person).should == @person
    end
  end

  it "should get show" do
    Person.should_receive(:find).and_return @person
    get :show
    response.should be_success
  end

  it "should update person" do
    @person.should_receive(:update_attributes).and_return true
    Person.should_receive(:find).and_return @person
    post :update
    flash[:notice].should_not be_empty
  end


end
