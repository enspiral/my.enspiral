#one way migration
class CleanTeamsWorkedOn < ActiveRecord::Migration
  def self.up
    drop_table :teams if self.table_exists?("teams")
    drop_table :worked_ons if self.table_exists?("worked_ons")
    remove_column :people, :team_id
  end

  def self.down
  end

  def table_exists?
    ActiveRecord::Base.connection.tables.include?(name)
  end
end
