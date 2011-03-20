class AddHasGravatarToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :has_gravatar, :boolean, :default => false
  end

  def self.down
    remove_column :people, :has_gravatar
  end
end
