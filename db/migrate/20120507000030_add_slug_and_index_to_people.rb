class AddSlugAndIndexToPeople < ActiveRecord::Migration
  def change
    #moved to DowncaseExistingEmails
    #add_column :people, :slug, :string
    #add_index :people, :slug, :unique => true
  end
end
