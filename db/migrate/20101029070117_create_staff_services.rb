class CreateStaffServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.references :person
      t.references :service_category
      t.text :description
      t.float :rate
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
