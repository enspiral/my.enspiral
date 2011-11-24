class CreateProjectPeople < ActiveRecord::Migration
  def change
    create_table :project_people do |t|
      t.references :person
      t.references :project

      t.timestamps
    end
    add_index :project_people, :person_id
    add_index :project_people, :project_id
  end
end
