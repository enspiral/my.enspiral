require 'spec_helper'

describe BadgeOwnershipsController do

  def mock_badge_ownership(stubs={})
    @mock_badge_ownership ||= mock_model(BadgeOwnership, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all badge_ownerships as @badge_ownerships" do
      BadgeOwnership.stub(:order) { [mock_badge_ownership] }
      get :index
      assigns(:badge_ownerships).should eq([mock_badge_ownership])
    end
  end

  describe "GET new" do
    it "assigns a new badge_ownership as @badge_ownership" do
      BadgeOwnership.stub(:new) { mock_badge_ownership }
      get :new
      assigns(:badge_ownership).should be(mock_badge_ownership)
    end
  end

  describe "GET edit" do

    it "assigns the requested badge_ownership as @badge_ownership" do
      log_in User.make
      BadgeOwnership.stub(:find).with("37") { mock_badge_ownership }
      get :edit, :id => "37"
      assigns(:badge_ownership).should be(mock_badge_ownership)
    end

    it "should redirect if not current user" do
      @user = User.make!
      @user1 = User.make!
      @person = Person.make!
      @person1 = Person.make!
      @badge_ownership = BadgeOwnership.make!
      @badge_ownership.stub!(:person).and_return(@person)
      @user1.stub!(:person).and_return(@person1)
      controller.stub!(:current_user).and_return(@user)
      log_in @user1
      get :edit, :id => @badge_ownership.id
      response.should redirect_to badge_ownerships_path
    end
  end

  describe "POST create" do
    before(:each) do
      log_in User.make
    end
    describe "with valid params" do
      it "assigns a newly created badge_ownership as @badge_ownership" do
        BadgeOwnership.stub(:new).with({'these' => 'params'}) { mock_badge_ownership(:save => true) }
        post :create, :badge_ownership => {'these' => 'params'}
        assigns(:badge_ownership).should be(mock_badge_ownership)
      end

      it "redirects to the badge_ownerships index page" do
        BadgeOwnership.stub(:new) { mock_badge_ownership(:save => true) }
        post :create, :badge_ownership => {}
        response.should redirect_to(badge_ownerships_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved badge_ownership as @badge_ownership" do
        BadgeOwnership.stub(:new).with({'these' => 'params'}) { mock_badge_ownership(:save => false) }
        post :create, :badge_ownership => {'these' => 'params'}
        assigns(:badge_ownership).should be(mock_badge_ownership)
      end

      it "re-renders the 'new' template" do
        BadgeOwnership.stub(:new) { mock_badge_ownership(:save => false) }
        post :create, :badge_ownership => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      log_in User.make!
    end

    describe "with valid params" do
      it "updates the requested badge_ownership" do
        BadgeOwnership.stub(:find).with("37") { mock_badge_ownership }
        mock_badge_ownership.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :badge_ownership => {'these' => 'params'}
      end

      it "assigns the requested badge_ownership as @badge_ownership" do
        BadgeOwnership.stub(:find) { mock_badge_ownership(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:badge_ownership).should be(mock_badge_ownership)
      end

      it "redirects to the badge_ownerships index" do
        BadgeOwnership.stub(:find) { mock_badge_ownership(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(badge_ownerships_path)
      end
  end

    describe "with invalid params" do
      it "assigns the badge_ownership as @badge_ownership" do
        BadgeOwnership.stub(:find) { mock_badge_ownership(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:badge_ownership).should be(mock_badge_ownership)
      end

      it "re-renders the 'edit' template" do
        BadgeOwnership.stub(:find) { mock_badge_ownership(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      log_in User.make!
    end

    it "destroys the requested badge_ownership" do
      BadgeOwnership.stub(:find).with("37") { mock_badge_ownership }
      mock_badge_ownership.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the badge_ownerships list" do
      BadgeOwnership.stub(:find) { mock_badge_ownership }
      delete :destroy, :id => "1"
      response.should redirect_to(badge_ownerships_url)
    end
  end
end
