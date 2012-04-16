class RemoveBadges < ActiveRecord::Migration
  def up
    drop_table :badges
    drop_table :badge_ownerships
  end

  def down
    # dont go down!
  end
end
