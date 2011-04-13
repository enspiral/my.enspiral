class AddCreatedByToBadges < ActiveRecord::Migration
  def self.up
    add_column :badges, :created_by, :int
  end

  def self.down
    remove_column :badges, :created_by
  end
end
