class RemovePersonIdFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :person_id
      end

  def down
    add_column :accounts, :person_id, :string
  end
end
