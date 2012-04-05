class PerUserAccountCleanup < ActiveRecord::Migration
  def up
    if table_exists? :project_people
      remove_index :project_people, :person_id if index_exists? :project_people, :person_id
      remove_index :project_people, :project_id if index_exists? :project_people, :project_id
      drop_table :project_people 
    end
  end
end
