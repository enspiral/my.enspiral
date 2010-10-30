require 'spec_helper'

describe PeopleController do
  setup :activate_authlogic
  
  before(:each) do
    @user = User.make
    @user.save!
    @person = Person.make :user => @user
    @person.save!
    @country = Country.make
    @country.save!
    @city = City.make :country => @country
    @city.save!
    login_as @user
  end

  it "should update person with existing country and city" do
    put :update_profile, :person => { :country_id => @country.id, :city_id => @city.id }
    
    @person.reload
    @person.country.should eql(@country)
    @person.city.should eql(@city)
  end
  
  it "should update person with existing country but new city" do
    city_name = Faker::Lorem.words.join ' '
    
    put :update_profile, :person => { :country_id => @country.id, :city_id => @city.id }, :city => city_name
    
    @person.reload
    @person.country.should eql(@country)
    city = @country.cities.where(:name => city_name).first
    city.should_not be_blank
    @person.city.should eql(city)
  end
  
  it "should update person with new country and city" do
    country_name = Faker::Lorem.words.join ' '
    city_name = Faker::Lorem.words.join ' '
    
    put :update_profile, :person => { :country_id => @country.id, :city_id => @city.id }, :country => country_name, :city => city_name
    
    @person.reload
    country = Country.where(:name => country_name).first
    country.should_not be_blank
    @person.country.should eql(country)
    city = country.cities.where(:name => city_name).first
    city.should_not be_blank
    @person.city.should eql(city)
  end
  
  it "should update person with new country but existing city" do
    country_name = Faker::Lorem.words.join ' '
    
    put :update_profile, :person => { :country_id => @country.id, :city_id => @city.id }, :country => country_name
    
    @person.reload
    country = Country.where(:name => country_name).first
    country.should_not be_blank
    @person.country.should eql(country)
    @person.city.should be_blank
  end

end
