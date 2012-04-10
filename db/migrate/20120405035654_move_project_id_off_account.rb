class MoveProjectIdOffAccount < ActiveRecord::Migration
  def up
    add_column :projects, :account_id, :integer
    remove_column :accounts, :project_id
  end

  def down
    add_column :accounts, :project_id
    remove_column :projects, :account_id
  end
end
