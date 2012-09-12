class ContractFields < ActiveRecord::Migration
  def change
    rename_column :contracts, :title, :name
    add_column :contracts, :active, :boolean, default: true
    add_column :contracts, :private, :boolean, default: false
    add_column :contracts, :description, :text
  end
end
