class RemoveRememberTokenFromUser < ActiveRecord::Migration
  def up
    if column_exists? :users, :remember_token
      remove_column :users, :remember_token
    end
  end

  def down
    add_column :users, :remember_token, :string
  end
end
