class PostgresFixes < ActiveRecord::Migration
  def up
    #says it doesn't exist
    #remove_index :availabilities, :person_id
    #drop_table :availabilities
    remove_index :bookings, :project_id
    remove_index :bookings, :person_id
    drop_table :bookings
    change_column :feed_entries, :summary, :text
  end

  def down
    change_column :feed_entries, :summary, :string
  end
end
