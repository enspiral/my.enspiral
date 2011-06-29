#one way migration
class CleanTeamsWorkedOn < ActiveRecord::Migration
  def self.up
    remove_column :people, :team_id
  end

  def self.down
    add_column :people, :team_id, :integer
  end
end
