class ActiveAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :active, :boolean, :default => true
    Person.all.each do |p|
      p.account.update_attribute(:active, p.active)
    end
  end

  def down
    remove_column :accounts, :active
  end
end
