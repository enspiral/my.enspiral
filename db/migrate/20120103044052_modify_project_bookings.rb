class ModifyProjectBookings < ActiveRecord::Migration
  def up
    remove_column :project_bookings, :person_id
    remove_column :project_bookings, :project_id
  end

  def down
    add_column :project_bookings, :person_id, :integer
    add_column :project_bookings, :project_id, :integer
  end
end
