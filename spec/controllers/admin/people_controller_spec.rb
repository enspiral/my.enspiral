require 'spec_helper'

describe Admin::PeopleController do
  before(:each) do
    log_in User.make(:admin)
  end

  it "should get new" do
    get :new
    response.should be_success
  end

  it "should create person" do
    person = mock_model(Person).as_null_object
    person.should_receive(:save).and_return true
    Person.stub(:new).and_return person
    post :create
    response.should redirect_to(admin_person_path(person))
  end

  it "should get edit" do
    person = mock_model(Person)
    Person.should_receive(:find).and_return person
    get :edit
    response.should be_success
  end

  it "should get show" do
    person = mock_model(Person)
    Person.should_receive(:find).and_return person
    get :show
    response.should be_success
  end

  it "should update person" do
    person = mock_model(Person).as_null_object
    person.should_receive(:update_attributes).and_return true
    Person.should_receive(:find).and_return person
    post :update
    flash[:notice].should_not be_empty
    response.should redirect_to(admin_person_path(person))
  end

  it "should destroy person" do
    person = double(:destroy => true)
    Person.should_receive(:find).and_return person
    post :destroy
    response.should redirect_to(admin_people_path)
  end

end
