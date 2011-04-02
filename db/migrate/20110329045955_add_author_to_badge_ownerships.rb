class AddAuthorToBadgeOwnerships < ActiveRecord::Migration
  def self.up
    add_column :badge_ownerships, :person_id, :int
  end

  def self.down
    remove_column :badge_ownerships, :person_id
  end
end
