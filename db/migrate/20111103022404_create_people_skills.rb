class CreatePeopleSkills < ActiveRecord::Migration
  def change
    create_table :people_skills do |t|
      t.integer :skill_id
      t.integer :person_id

      t.timestamps
    end
  end
end
