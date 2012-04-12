class UpdateDeviseColumns < ActiveRecord::Migration
  def up
    if column_exists? :users, :remember_token
      remove_column :users, :remember_token
    end
    unless column_exists? :users, :reset_password_sent_at
      add_column :users, :reset_password_sent_at, :datetime
    end
  end

  def down
    add_column :users, :remember_token, :string
    remove_column :users, :reset_password_sent_at
  end
end
