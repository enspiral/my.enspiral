require 'spec_helper'

describe PeopleController do
  before(:each) do
    @user = User.make
    @user.save!
    @person = Person.make :user => @user
    @person.save!
    @country = Country.make
    @country.save!
    @city = City.make :country => @country
    @city.save!
    log_in @user
  end

  it "should update person with existing country and city" do
    put :update, :person => { :country_id => @country.id, :city_id => @city.id }
    
    @person.reload
    @person.country.should eql(@country)
    @person.city.should eql(@city)
  end
  
  it "should update person with existing country but new city" do
    pending
    city_name = Faker::Lorem.words.join ' '
    
    put :update, :person => { :country_id => @country.id, :city_id => @city.id }, :city => city_name
    
    @person.reload
    @person.country.should eql(@country)
    city = @country.cities.where(:name => city_name).first
    city.should_not be_blank
    @person.city.should eql(city)
  end
  
  it "should update person with new country and city" do
    pending
    country_name = Faker::Lorem.words.join ' '
    city_name = Faker::Lorem.words.join ' '
    
    put :update, :person => { :country_id => @country.id, :city_id => @city.id }, :country => country_name, :city => city_name
    
    @person.reload
    country = Country.where(:name => country_name).first
    country.should_not be_blank
    @person.country.should eql(country)
    city = country.cities.where(:name => city_name).first
    city.should_not be_blank
    @person.city.should eql(city)
  end
  
  it "should update person with new country but existing city" do
    pending
    country_name = Faker::Lorem.words.join ' '
    
    put :update, :person => { :country_id => @country.id, :city_id => @city.id }, :country => country_name
    
    @person.reload
    country = Country.where(:name => country_name).first
    country.should_not be_blank
    @person.country.should eql(country)
    @person.city.should be_blank
  end
  
  it "should update person with existing country and city but with country name that already exists" do
    pending
    new_country = Country.make
    new_country.save!
    new_city = City.make :country => new_country
    new_city.save!
    
    put :update, :person => { :country_id => new_country.id, :city_id => new_city.id }, :country => @country.name
    
    @person.reload
    @person.country.should eql(@country)
    @person.city.should be_blank
  end
  
  it "should update person with existing country and city but with city name that already exists" do
    pending
    new_city = City.make :country => @country
    new_city.save!
    
    put :update, :person => { :country_id => @country.id, :city_id => new_city.id }, :city => @city.name
    
    @person.reload
    @person.country.should eql(@country)
    @person.city.should eql(@city)
  end

  describe "editing" do
    it "successfully load" do
      get :edit, :id => @person.id
      response.should be_success
    end
    it "should load the current user" do
      get :edit, :id => @person.id
      assigns(:person).should == @person
    end

    it "should redirect if not current user" do
      p2 = Person.make!
      Person.stub(:find).and_return(p2)
      get :edit
      response.should be_redirect
    end
  end

  it "should get show" do
    Person.should_receive(:find).and_return @person
    get :show
    response.should be_success
  end

  it "should update person" do
    pending
    person = mock_model(Person).as_null_object
    person.should_receive(:update_attributes).and_return true
    controller.stub(:current_person).and_return(person)
    post :update
    flash[:notice].should_not be_empty
    response.should redirect_to(people_path)
  end

  context "Logged in admin" do
    before(:each) do
      admin = Person.make :admin
      log_in admin.user
      @person = mock_model(Person).as_null_object
    end
    it "should activate person" do
      @person.should_receive(:activate).and_return true
      @person.stub_chain(:user, :update_attribute).and_return(@user)
      Person.stub(:find).and_return @person
      get :activate, :id => @person.id
      response.should redirect_to people_path
    end

    it "should deactivate person" do
      @person.should_receive(:deactivate).and_return true
      @person.stub_chain(:user, :update_attribute).and_return(@user)
      Person.stub(:find).and_return @person
      get :deactivate, :id => @person.id
      response.should redirect_to people_path
    end
  end
end
