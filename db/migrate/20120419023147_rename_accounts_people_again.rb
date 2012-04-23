class RenameAccountsPeopleAgain < ActiveRecord::Migration
  def up
    if column_exists? :accounts, :person_id
      remove_column :accounts, :person_id
    end
  end

  def down
  end
end
