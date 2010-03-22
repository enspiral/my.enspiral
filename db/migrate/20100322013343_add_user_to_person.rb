class AddUserToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :user_id, :integer
    add_column :users, :role, :string
  end

  def self.down
    remove_column :people, :user_id
    remove_column :users, :role
  end
end
