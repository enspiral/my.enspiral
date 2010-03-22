require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  should "get new" do
    get :new
    assert_response :success
    assert !assigns(:user_session).nil?
  end

  should  "redirect correctly when admin" do
    post :create, :user_session => {:email => 'joshua@enspiral.com', :password => 'password'}
    assert_redirected_to people_url
  end

  should "redirect correctly when staff" do
    post :create, :user_session => {:email => 'sam@enspiral.com', :password => 'password'}
    assert_redirected_to user_path(users(:sam))
  end

  should "show error when password invalid" do
    post :create, :user_session => {:email => 'sam@enspiral.com', :password => 'wrong-password'}
    assert_response :success
    assert_select '.error'
  end

end
