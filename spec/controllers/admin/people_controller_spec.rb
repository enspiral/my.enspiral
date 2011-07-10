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
    person = Person.make!
    country = Country.make!
    get :show, :id => person.id, :person => {:country_id => country.id}
    response.should be_success
    response.should render_template('staff/dashboard/dashboard')
  end

  it "should update person" do
    person = Person.make!
    country = Country.make!
    post :update, :id => person.id, :person => {:country_id => country.id}
    flash[:notice].should_not be_empty
    response.should redirect_to('/people')
  end

  it "should destroy person" do
    person = double(:destroy => true)
    Person.should_receive(:find).and_return person
    post :destroy
    response.should redirect_to(admin_people_path)
  end

  context "when user balances is called" do
    before(:each) do
      @person = Person.make!
      make_financials(@person)
    end

    it "without a limit should return all them" do
      get :balances, :person_id => @person
      response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
    end

    it "with a limit should return a subset of balances" do
      get :balances, :person_id => @person, :limit => 2
      response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"]]"
    end
  end
end
