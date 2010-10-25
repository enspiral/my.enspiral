require 'spec_helper'

describe PeopleController do
  setup :activate_authlogic

  before(:each) do
    login_as User.make(:staff)
    request.env["HTTP_REFERER"] = 'http://somewhere.com'
  end

  it "should get edit" do
    person = mock_model(Person)
    Person.should_receive(:find).and_return person
    get :edit
    response.should be_success
  end

  it "should get show" do
    person = mock_model(Person).as_null_object
    Person.should_receive(:find).and_return person
    get :show
    response.should be_success
  end

  it "should update person" do
    person = Person.make
    person.save!
    person.should_receive(:update_attributes).and_return true
    Person.should_receive(:find).and_return person
    post :update
    flash[:notice].should_not be_empty
  end


end
