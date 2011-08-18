require 'spec_helper'

describe GoalsController do
  before(:each) do
    sign_in User.make!
  end

  def mock_goal(stubs={})
    @mock_goal ||= mock_model(Goal, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all goals as @goals" do
      Goal.stub(:where) { [mock_goal] }
      get :index
      response.should be_success
      assigns(:goals).should eq([mock_goal])
    end
  end

  describe "GET new" do
    it "assigns a new goal as @goal" do
      Goal.stub(:new) { mock_goal }
      get :new
      assigns(:goal).should be(mock_goal)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created goal as @goal" do
        Goal.stub(:new).with({'these' => 'params'}) { mock_goal(:save => true) }
        post :create, :goal => {'these' => 'params'}
        assigns(:goal).should be(mock_goal)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved goal as @goal" do
        Goal.stub(:new).with({'these' => 'params'}) { mock_goal(:save => false) }
        post :create, :goal => {'these' => 'params'}
        assigns(:goal).should be(mock_goal)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested goal" do
        Goal.stub(:find).with("37") { mock_goal }
        mock_goal.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :goal => {'these' => 'params'}
      end

      it "assigns the requested goal as @goal" do
        Goal.stub(:find) { mock_goal(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:goal).should be(mock_goal)
      end
    end

    describe "with invalid params" do
      it "assigns the goal as @goal" do
        Goal.stub(:find) { mock_goal(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:goal).should be(mock_goal)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested goal" do
      Goal.stub(:find).with("37") { mock_goal }
      mock_goal.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  end
end
