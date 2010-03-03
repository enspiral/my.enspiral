class RenameLocationToCityInPerson < ActiveRecord::Migration
  def self.up
	rename_column :people, :location, :city
  end

  def self.down
	rename_column :people, :city, :location  
  end
end
