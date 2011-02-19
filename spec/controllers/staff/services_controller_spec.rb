require 'spec_helper'

describe Staff::ServicesController do
  before(:each) do
    @user = User.make
    @user.save!
    @person = Person.make :user => @user
    @person.save!
    @service_category = ServiceCategory.make
    @service_category.save!
    log_in @user
    controller.stub(:current_person) { @person }
  end

  def mock_service(stubs={})
    (@mock_service ||= mock_model(Service).as_null_object).tap do |service|
      service.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all services as @services" do
      Service.stub(:all) { [mock_service] }
      get :index
      assigns(:services).should eq([mock_service])
    end
  end

  # describe "GET show" do
  #   it "assigns the requested service as @service" do
  #     Service.stub(:find).with("37") { mock_service }
  #     get :show, :id => "37"
  #     assigns(:service).should be(mock_service)
  #   end
  # end

  describe "GET new" do
    it "assigns a new service as @service" do
      @person.services.stub(:new) { mock_service }
      get :new
      assigns(:service).should be(mock_service)
    end
  end

  describe "GET edit" do
    it "assigns the requested service as @service" do
      @person.services.stub(:find).with("37") { mock_service }
      get :edit, :id => "37"
      assigns(:service).should be(mock_service)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created service as @service" do
        @person.services.stub(:new).with({'service_category_id' => @service_category.id, 'description' => 'description', 'rate' => 50}) { mock_service(:save => true) }
        post :create, :service => {'service_category_id' => @service_category.id, 'description' => 'description', 'rate' => 50}
        assigns(:service).should be(mock_service)
      end

      it "redirects to the created service" do
        @person.services.stub(:new) { mock_service(:save => true) }
        post :create, :service => {}
        response.should redirect_to(staff_services_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved service as @service" do
        @person.services.stub(:new).with({'these' => 'params'}) { mock_service(:save => false) }
        post :create, :service => {'these' => 'params'}
        assigns(:service).should be(mock_service)
      end

      it "re-renders the 'new' template" do
        @person.services.stub(:new) { mock_service(:save => false) }
        post :create, :service => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested service" do
        @person.services.should_receive(:find).with("37") { mock_service }
        mock_service.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :service => {'these' => 'params'}
      end

      it "assigns the requested service as @service" do
        @person.services.stub(:find) { mock_service(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:service).should be(mock_service)
      end

      it "redirects to the service" do
        @person.services.stub(:find) { mock_service(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(staff_services_url)
      end
    end

    describe "with invalid params" do
      it "assigns the service as @service" do
        @person.services.stub(:find) { mock_service(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:service).should be(mock_service)
      end

      it "re-renders the 'edit' template" do
        @person.services.stub(:find) { mock_service(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested service" do
      @person.services.should_receive(:find).with("37") { mock_service }
      mock_service.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the staff_services list" do
      @person.services.stub(:find) { mock_service }
      delete :destroy, :id => "1"
      response.should redirect_to(staff_services_url)
    end
  end

end
