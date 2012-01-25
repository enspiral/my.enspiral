class ModifyAvailabilitiesAndBookings < ActiveRecord::Migration
  def up
    drop_table :bookings
    change_table :availabilities do |t|
      t.references :project
      t.string :role
    end
    add_index :availabilities, :project_id
  end

  def down
    create_table :bookings do |t|
      t.references :project
      t.references :person
      t.integer :time
      t.datetime :week

      t.timestamps
    end
    add_index :bookings, :project_id
    add_index :bookings, :person_id

    remove_index :availabilities, :project_id
    remove_column :availabilities, :role
    remove_column :availabilities, :project_id
  end
end
