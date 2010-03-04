require 'test_helper'

class PersonTest < ActiveSupport::TestCase

	should "have email" do
		lachlan = Person.find_by_email "lachlan.scott@me.com"
		assert !lachlan.nil?
	end
	
	should "have account on create" do
		p = Person.new
		assert_equal nil, p.account
		
		p.email = "test@somewhere.com"
		
		assert_difference 'Account.count' do
			p.save
		end
		p.reload
		assert !p.account.nil?
	end
end
