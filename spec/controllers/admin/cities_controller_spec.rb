require 'spec_helper'

describe Admin::CitiesController do
  setup :activate_authlogic
  
  before(:each) do
    @country = Country.make
    @country.save!
    login_as User.make(:admin)
  end

  def mock_city(stubs={})
    (@mock_city ||= mock_model(City).as_null_object).tap do |city|
      city.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all cities as @cities" do
      City.stub(:all) { [mock_city] }
      get :index
      assigns(:cities).should eq([mock_city])
    end
  end

  # describe "GET show" do
  #   it "assigns the requested city as @city" do
  #     City.stub(:find).with("37") { mock_city }
  #     get :show, :id => "37"
  #     assigns(:city).should be(mock_city)
  #   end
  # end

  describe "GET new" do
    it "assigns a new city as @city" do
      City.stub(:new) { mock_city }
      get :new
      assigns(:city).should be(mock_city)
    end
  end

  describe "GET edit" do
    it "assigns the requested city as @city" do
      City.stub(:find).with("37") { mock_city }
      get :edit, :id => "37"
      assigns(:city).should be(mock_city)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created city as @city" do
        City.stub(:new).with({'country_id' => @country.id, 'name' => 'name'}) { mock_city(:save => true) }
        post :create, :city => {'country_id' => @country.id, 'name' => 'name'}
        assigns(:city).should be(mock_city)
      end

      it "redirects to the created city" do
        City.stub(:new) { mock_city(:save => true) }
        post :create, :city => {}
        response.should redirect_to(admin_cities_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved city as @city" do
        City.stub(:new).with({'these' => 'params'}) { mock_city(:save => false) }
        post :create, :city => {'these' => 'params'}
        assigns(:city).should be(mock_city)
      end

      it "re-renders the 'new' template" do
        City.stub(:new) { mock_city(:save => false) }
        post :create, :city => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested city" do
        City.should_receive(:find).with("37") { mock_city }
        mock_city.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :city => {'these' => 'params'}
      end

      it "assigns the requested city as @city" do
        City.stub(:find) { mock_city(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:city).should be(mock_city)
      end

      it "redirects to the city" do
        City.stub(:find) { mock_city(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_cities_url)
      end
    end

    describe "with invalid params" do
      it "assigns the city as @city" do
        City.stub(:find) { mock_city(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:city).should be(mock_city)
      end

      it "re-renders the 'edit' template" do
        City.stub(:find) { mock_city(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested city" do
      City.should_receive(:find).with("37") { mock_city }
      mock_city.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the cities list" do
      City.stub(:find) { mock_city }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_cities_url)
    end
  end

end
