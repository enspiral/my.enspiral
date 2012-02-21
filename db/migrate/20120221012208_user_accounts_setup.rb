class UserAccountsSetup < ActiveRecord::Migration
  def up
    create_table :account_permissions do |t|
      t.references :account
      t.references :person
      t.string :role
      t.timestamps
    end
    add_column :accounts, :name, :string
    add_column :accounts, :project_id, :integer
    add_column :accounts, :active, :boolean, :default => true
    add_column :invoice_allocations, :account_id, :integer
    InvoiceAllocation.all.each do |allocation|
      allocation.update_attribute(:account_id, allocation.person.account.id) if allocation.person.present?
    end
    Person.all.each do |p|
      p.account.update_attribute(:active, p.active)
    end
  end

  def down
    remove_column :accounts, :name
    remove_column :accounts, :project_id
    remove_column :invoice_allocations, :account_id
    remove_column :accounts, :active
    drop_table :account_permissions
  end
end

