class RenameAccountsPeopleAgain < ActiveRecord::Migration
  def up
    rename_table :people_accounts, :accounts_people
    if column_exists? :accounts, :person_id
      remove_column :accounts, :person_id
    end
  end

  def down
    rename_table :accounts_people, :people_accounts
  end
end
