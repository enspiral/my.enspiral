class CreatePeopleGroups < ActiveRecord::Migration
  def change
    create_table :people_groups do |t|
      t.integer :group_id
      t.integer :person_id

      t.timestamps
    end
  end
end
