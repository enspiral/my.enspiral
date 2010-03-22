module TeamsHelper
	def non_members_for_select(team)
		team.non_members.collect {|p| [p.name, p.id]}
	end
	

end
