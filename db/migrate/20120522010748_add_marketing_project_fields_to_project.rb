class AddMarketingProjectFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :url, :string
    add_column :projects, :client, :string
    add_column :projects, :tagline, :string
    add_column :projects, :about, :text
    add_column :projects, :published, :boolean
  end
end
