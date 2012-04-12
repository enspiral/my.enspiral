class AddProfileImageToPeople < ActiveRecord::Migration
  def change
    add_column :people, :profile_image, :string
  end
end
