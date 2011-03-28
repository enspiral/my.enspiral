class AddActiveFieldToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :active, :boolean, :default => true
    add_column :users, :active, :boolean, :default => true
  end

  def self.down
    remove_column :users, :active
    remove_column :people, :active
  end
end
