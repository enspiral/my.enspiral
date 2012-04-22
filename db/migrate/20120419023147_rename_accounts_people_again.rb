class RenameAccountsPeopleAgain < ActiveRecord::Migration
  def up
    if table_exists? :people_accounts
      if table_exists? :accounts_people
        drop_table :accounts_people
      end
      rename_table :people_accounts, :accounts_people
    end
    if column_exists? :accounts, :person_id
      remove_column :accounts, :person_id
    end
  end

  def down
    rename_table :accounts_people, :people_accounts
  end
end
