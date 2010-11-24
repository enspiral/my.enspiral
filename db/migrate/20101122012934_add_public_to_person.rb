class AddPublicToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :public, :boolean, :default => false
  end

  def self.down
    remove_column :people, :public
  end
end
