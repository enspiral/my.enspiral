class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :person
      t.date :week
      t.integer :time

      t.timestamps
    end
    add_index :availabilities, :person_id
  end
end
