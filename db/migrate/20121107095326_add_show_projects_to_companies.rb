class AddShowProjectsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :show_projects, :boolean, default: true
  end
end
