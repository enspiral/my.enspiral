class Team < ActiveRecord::Base
	has_many :people
	
	def non_members
		Person.all(:order => "first_name") - people
	end
end
