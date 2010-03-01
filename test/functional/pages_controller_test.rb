require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	context "viewing contact page" do
		setup do
			@person = people(:lachlan)
			get :contact
		end
		
		should "assign phone number" do
			assert_equal "khggj", assigns(:phone_number)
		end
	end
	
end
