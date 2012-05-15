class FixWebsiteSpellingInCompanies < ActiveRecord::Migration
  def change
    rename_column :companies, :webiste, :website
  end
end
