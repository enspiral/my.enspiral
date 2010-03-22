require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup :activate_authlogic

  context "public" do

    context "viewing index page" do
      setup do
        get :index
        assert_response :success
      end

      should "find people" do
        assert_not_nil assigns(:people)
      end

      should "not new person link" do
        assert_select "a[href=#{new_admin_person_path}]", false
      end

      should "not show edit person link" do
        assert_select "a[href=#{edit_admin_person_path(people(:joshua))}]", false
      end
    end

    should "should show person" do
      get :show, :id => people(:lachlan).to_param
      assert_response :success
    end
  end

  context "admin" do
    setup do
      login_as :joshua
    end

    context "viewing index page" do
      setup do
        get :index
        assert_response :success
      end

      should "show new person link" do
        assert_select "a[href=#{new_admin_person_path}]"
      end

      should "show edit person link" do
        assert_select "a[href=#{edit_admin_person_path(people(:joshua))}]"
      end
    end
  end
end
