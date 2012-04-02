class PostgresFixes < ActiveRecord::Migration
  def up
    remove_index :availabilities, :person_id if index_exists? :availabilities, :person_id
    drop_table :availabilities if table_exists? :availabilities
    remove_index :bookings, :project_id if index_exists? :bookings, :project_id
    remove_index :bookings, :person_id if index_exists? :bookings, :person_id
    drop_table :bookings if table_exists? :bookings
    change_column :feed_entries, :summary, :text
  end

  def down
    change_column :feed_entries, :summary, :string
  end
end
