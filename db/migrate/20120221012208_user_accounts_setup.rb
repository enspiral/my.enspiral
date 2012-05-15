class UserAccountsSetup < ActiveRecord::Migration
  def up
    create_table :accounts_people, :force => true do |t|
      t.references :account
      t.references :person
      t.string :role
      t.timestamps
    end

    add_column :people, :account_id, :integer
    add_column :accounts, :name, :string unless column_exists? :accounts, :name
    add_column :accounts, :category, :string
    # migrate account id to person
    Account.where('person_id is not null').each do |a|
      if p = Person.where(id: a.person_id).first
        p.accounts << a
        a.update_attribute(:name, "#{p.name}'s Enspiral Account")
      end
    end

    add_column :accounts, :project_id, :integer unless column_exists? :accounts, :project_id
    add_column :accounts, :active, :boolean, :default => true unless column_exists? :accounts, :active
    add_column :invoice_allocations, :account_id, :integer unless column_exists? :invoice_allocations, :account_id

    InvoiceAllocation.all.each do |allocation|
      if allocation.person_id.present?
        person = Person.find(allocation.person_id)
        allocation.update_attribute(:account_id, person.accounts.first.id)
      else
        puts "no account for #{allocation.person.name}"
      end
    end
    Person.all.each do |p|
      p.accounts.first.update_attribute(:active, p.active)
    end
  end

  def down
    remove_column :accounts, :category
    remove_column :accounts, :name
    remove_column :accounts, :project_id
    remove_column :invoice_allocations, :account_id
    remove_column :accounts, :active
    drop_table :account_permissions
  end
end

