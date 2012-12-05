require 'spec_helper'

describe Marketing::PeopleController do
  before(:each) do
    @person = Enspiral::CompanyNet::Person.make!
    sign_in @person.user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @person.slug
      response.should be_success
    end
  end

end
