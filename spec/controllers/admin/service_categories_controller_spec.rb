require 'spec_helper'

describe Admin::ServiceCategoriesController do
  before(:each) do
    log_in User.make(:admin)
  end

  def mock_service_category(stubs={})
    (@mock_service_category ||= mock_model(ServiceCategory).as_null_object).tap do |service_category|
      service_category.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all service_categories as @service_categories" do
      ServiceCategory.stub(:all) { [mock_service_category] }
      get :index
      assigns(:service_categories).should eq([mock_service_category])
    end
  end

  describe "GET show" do
    it "assigns the requested service_category as @service_category" do
      ServiceCategory.stub(:find).with("37") { mock_service_category }
      get :show, :id => "37"
      assigns(:service_category).should be(mock_service_category)
    end
  end

  describe "GET new" do
    it "assigns a new service_category as @service_category" do
      ServiceCategory.stub(:new) { mock_service_category }
      get :new
      assigns(:service_category).should be(mock_service_category)
    end
  end

  describe "GET edit" do
    it "assigns the requested service_category as @service_category" do
      ServiceCategory.stub(:find).with("37") { mock_service_category }
      get :edit, :id => "37"
      assigns(:service_category).should be(mock_service_category)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created service_category as @service_category" do
        ServiceCategory.stub(:new).with({'name' => 'name'}) { mock_service_category(:save => true) }
        post :create, :service_category => {'name' => 'name'}
        assigns(:service_category).should be(mock_service_category)
      end

      it "redirects to the created service_category" do
        ServiceCategory.stub(:new) { mock_service_category(:save => true) }
        post :create, :service_category => {}
        response.should redirect_to(admin_service_categories_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved service_category as @service_category" do
        ServiceCategory.stub(:new).with({'these' => 'params'}) { mock_service_category(:save => false) }
        post :create, :service_category => {'these' => 'params'}
        assigns(:service_category).should be(mock_service_category)
      end

      it "re-renders the 'new' template" do
        ServiceCategory.stub(:new) { mock_service_category(:save => false) }
        post :create, :service_category => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested service_category" do
        ServiceCategory.should_receive(:find).with("37") { mock_service_category }
        mock_service_category.should_receive(:update_attributes).with({'name' => 'name'})
        put :update, :id => "37", :service_category => {'name' => 'name'}
      end

      it "assigns the requested service_category as @service_category" do
        ServiceCategory.stub(:find) { mock_service_category(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:service_category).should be(mock_service_category)
      end

      it "redirects to the service_category" do
        ServiceCategory.stub(:find) { mock_service_category(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_service_categories_url)
      end
    end

    describe "with invalid params" do
      it "assigns the service_category as @service_category" do
        ServiceCategory.stub(:find) { mock_service_category(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:service_category).should be(mock_service_category)
      end

      it "re-renders the 'edit' template" do
        ServiceCategory.stub(:find) { mock_service_category(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested service_category" do
      ServiceCategory.should_receive(:find).with("37") { mock_service_category }
      mock_service_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the service_categories list" do
      ServiceCategory.stub(:find) { mock_service_category }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_service_categories_url)
    end
  end

end
