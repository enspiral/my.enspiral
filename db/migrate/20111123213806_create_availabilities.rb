class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :person
      t.integer :time
      t.datetime :week

      t.timestamps
    end
    add_index :availabilities, :person_id
  end
end
