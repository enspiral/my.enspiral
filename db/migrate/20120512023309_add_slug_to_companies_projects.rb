class AddSlugToCompaniesProjects < ActiveRecord::Migration
  def change
    add_column :projects, :slug, :string
    add_index :projects, :slug, :unique => true
    add_column :companies, :slug, :string
    add_index :companies, :slug, :unique => true
  end
end
