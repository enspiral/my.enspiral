class AddDescriptionToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :description, :text
  end
end
