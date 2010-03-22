require 'test_helper'

class Admin::PeopleControllerTest < ActionController::TestCase
  context "admin" do

    should "get new" do
      get :new
      assert_response :success
    end

    should "create person" do
      assert_difference('Person.count') do
        post :create, :person => {:email => 'myemail@somewhere.com' }
      end

      assert_redirected_to person_path(assigns(:person))
    end

    should "get edit" do
      get :edit, :id => people(:lachlan).to_param
      assert_response :success
    end

    should "update person" do
      @request.env["HTTP_REFERER"] = person_path(people(:lachlan))
      put :update, :id => people(:lachlan).to_param, :person => { }
      assert_redirected_to person_path(assigns(:person))
    end

    should "destroy person" do
      assert_difference('Person.count', -1) do
        delete :destroy, :id => people(:lachlan).to_param
      end

      assert_redirected_to people_path
    end

  end
end
