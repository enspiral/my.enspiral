class PerUserAccountCleanup < ActiveRecord::Migration
  def up
    remove_index :project_people, :person_id
    remove_index :project_people, :project_id
    drop_table :project_people
  end
end
