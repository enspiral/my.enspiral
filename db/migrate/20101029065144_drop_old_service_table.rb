class DropOldServiceTable < ActiveRecord::Migration
  def self.up
    drop_table :services
    drop_table :projects_services
  end

  def self.down
    create_table :services do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
