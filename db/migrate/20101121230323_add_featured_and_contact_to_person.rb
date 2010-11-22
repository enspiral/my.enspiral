class AddFeaturedAndContactToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :featured, :boolean, :default => false
    add_column :people, :contact, :boolean, :default => false
  end

  def self.down
    remove_column :people, :contact
    remove_column :people, :featured
  end
end
