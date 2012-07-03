class RenameDescriptionToNameOnSkills < ActiveRecord::Migration
  def up
    rename_column :skills, :description, :name
  end

  def down
    rename_column :skills, :name, :description
  end
end
