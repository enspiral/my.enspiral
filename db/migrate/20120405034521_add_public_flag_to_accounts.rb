class AddPublicFlagToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :public, :boolean
  end
end
