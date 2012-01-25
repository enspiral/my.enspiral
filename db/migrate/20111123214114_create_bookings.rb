class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :project
      t.references :person
      t.integer :time
      t.datetime :week

      t.timestamps
    end
    add_index :bookings, :project_id
    add_index :bookings, :person_id
  end
end
