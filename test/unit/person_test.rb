require 'test_helper'

class PersonTest < ActiveSupport::TestCase

	should "have email" do
		lachlan = Person.find_by_email "lachlan.scott@me.com"
		assert !lachlan.nil?
	end
end
