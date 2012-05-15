class AddTaglineToCompaniesProjects < ActiveRecord::Migration
  def change
    add_column :companies, :tagline, :string
    add_column :projects, :tagline, :string
  end
end
