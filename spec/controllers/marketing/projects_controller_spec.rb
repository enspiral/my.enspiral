require 'spec_helper'

describe Marketing::ProjectsController do
  before(:each) do
    @person = Person.make!
    sign_in @person.user
    @project = Project.make!
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @project.slug
      response.should be_success
    end
  end

end
