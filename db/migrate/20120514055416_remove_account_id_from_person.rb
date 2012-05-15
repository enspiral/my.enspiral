class RemoveAccountIdFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :account_id
  end
end
