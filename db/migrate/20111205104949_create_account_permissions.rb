class CreateAccountPermissions < ActiveRecord::Migration
  def change
    create_table :account_permissions do |t|
      t.references :account
      t.references :person
      t.string :role
      t.timestamps
    end
    add_column :accounts, :name, :string
    add_column :accounts, :project_id, :integer
  end
end
