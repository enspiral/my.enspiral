class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :person_id
      t.integer :balance, :default => 0

      t.timestamps
    end
	
	Person.all.each do |p|
		Account.create(:person_id => p.id)
	end
  end

  def self.down
    drop_table :accounts
  end
end
