class AddRateToPerson < ActiveRecord::Migration
  def change
    add_column :people, :rate, :decimal
  end
end
