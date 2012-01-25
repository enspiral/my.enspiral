class RenameProjectPeople < ActiveRecord::Migration
  def up
    rename_table :project_people, :project_memberships
  end

  def down
    rename_table :project_memberships, :project_people
  end
end
