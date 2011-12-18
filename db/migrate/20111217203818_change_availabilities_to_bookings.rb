class ChangeAvailabilitiesToBookings < ActiveRecord::Migration
  def up
    rename_table :availabilities, :project_bookings
    remove_column :project_bookings, :role
    
  end

  def down
    rename_table :project_bookings, :availabilities
    change_table :availabilities do |t|
      t.string :role
    end
  end
end
