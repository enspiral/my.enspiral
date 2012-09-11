require 'spec_helper'

describe SearchController do
  before(:each) do
    @person = Person.make!(:staff)
    sign_in @person.user
  end
    

  describe "GET 'index'" do
    it "returns http success" do
      pending
      get 'index'
      response.should be_success
    end
  end

end
