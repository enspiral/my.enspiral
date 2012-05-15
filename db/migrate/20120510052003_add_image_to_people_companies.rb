class AddImageToPeopleCompanies < ActiveRecord::Migration
  def change
    #moved to DowncaseExistingEmails to avoid errors
    #add_column :people, :image_uid, :string
    #moved to MakeEnspiralAndMakeItOwnItsStuff
    #add_column :companies, :image_uid, :string
  end
end
