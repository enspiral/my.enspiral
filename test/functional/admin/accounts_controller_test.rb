require 'test_helper'

class Admin::AccountsControllerTest < ActionController::TestCase
  context "admin" do
    setup do
      login_as :joshua
    end

    should "show index" do
      get :index
      assert_response :success
    end
  end
end
