class CreateBadgeOwnerships < ActiveRecord::Migration
  def self.up
    create_table :badge_ownerships do |t|
      t.integer :user_id
      t.integer :badge_id
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :badge_ownerships
  end
end
