class AddFeaturedAndContactToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :featured, :boolean
    add_column :people, :contact, :boolean
  end

  def self.down
    remove_column :people, :contact
    remove_column :people, :featured
  end
end
