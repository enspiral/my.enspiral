class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :person_id
      t.string :title
      t.text :description
      t.date :date
      t.text :completion_description
      t.integer :score, :default => 0

      t.timestamps
    end
  end
end
