class AddTeamToPerson < ActiveRecord::Migration
  def self.up
	# add ref to team
	    add_column :people, :team_id, :integer
  end

  def self.down
		remove_column :people, :team_id
  end
end
