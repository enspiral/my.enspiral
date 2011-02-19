class RemoveAuthlogicFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :persistence_token
  end

  def self.down
    add_column :users, :crypted_password, :string
  end
end
