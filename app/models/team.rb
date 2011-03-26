class Team < ActiveRecord::Base
	has_many :people
	
	def non_members
		Person.active.order("first_name") - people
	end
end
