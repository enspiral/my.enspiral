class RemovePeopleFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :person_id
  end

  def down
    add_column :projects, :person_id, :integer
  end
end
