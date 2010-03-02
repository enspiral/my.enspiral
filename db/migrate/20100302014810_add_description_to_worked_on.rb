class AddDescriptionToWorkedOn < ActiveRecord::Migration
  def self.up
    add_column :worked_ons, :description, :text
  end

  def self.down
    remove_column :worked_ons, :description
  end
end
