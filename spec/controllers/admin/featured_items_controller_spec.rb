require 'spec_helper'

describe Admin::FeaturedItemsController do
  it 'requires an admin' do
    get :index
    response.should be_redirect
  end

  describe 'a system admin' do
    before(:each) do
      @person = Enspiral::CompanyNet::Person.make!(:admin)
      sign_in @person.user
      @featured_item = FeaturedItem.make!
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        assigns(:featured_items)
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', id: @featured_item.id
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', id: @featured_item.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new', type: 'person'
        response.should be_success
      end
    end
  end

end
