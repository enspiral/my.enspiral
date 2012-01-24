require 'spec_helper'

describe "Staff::Person" do
  
  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user
    @person.default_hours_available = 40
    @person.save!

    login(@user)
  end

  describe "Person profile update page" do

    it "should enable the user to update their basic attributes" do
      visit edit_person_path(@person.id)

      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      country = 'Australia'
      city = 'Sydney'
      email = Faker::Internet.email
      phone = Faker::PhoneNumber.phone_number
      skype = 'Test_User'
      twitter = '@test_user'


      fill_in 'person_first_name', :with => first_name
      fill_in 'person_last_name', :with => last_name
      fill_in 'country', :with => country
      fill_in 'city', :with => city
      fill_in 'person_email', :with => email
      fill_in 'person_phone', :with => phone
      fill_in 'person_skype', :with => skype
      fill_in 'person_twitter', :with => twitter

      click_button 'Update'

      page.should have_content('success')



      edited_user = Person.find(@person.id)
      edited_user.first_name.should eq(first_name)
      edited_user.last_name.should eq(last_name)
      edited_user.country.name.should eq(country)
      edited_user.city.name.should eq(city)
      edited_user.email.should eq(email)
      edited_user.phone.should eq(phone)
      edited_user.skype.should eq(skype)
      edited_user.twitter.should eq(twitter)

    end

    it 'should enable a person to edit their skills (add new ones and remove old ones)' do

    end

  end
end
