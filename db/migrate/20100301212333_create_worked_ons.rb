class CreateWorkedOns < ActiveRecord::Migration
  def self.up
    create_table :worked_ons do |t|
      t.references :person
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :worked_ons
  end
end
