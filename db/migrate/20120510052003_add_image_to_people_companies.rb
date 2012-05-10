class AddImageToPeopleCompanies < ActiveRecord::Migration
  def change
    add_column :people, :image_uid, :string
    add_column :companies, :image_uid, :string
  end
end
