class AddAboutToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :about, :text
  end
end
