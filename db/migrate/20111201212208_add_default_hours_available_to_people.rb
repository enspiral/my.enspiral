class AddDefaultHoursAvailableToPeople < ActiveRecord::Migration
  def change
    add_column :people, :default_hours_available, :integer
  end
end
