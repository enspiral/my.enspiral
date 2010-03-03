class AddCityToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :city, :string
  end

  def self.down
    remove_column :projects, :city
  end
end
