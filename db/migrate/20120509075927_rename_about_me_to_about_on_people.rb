class RenameAboutMeToAboutOnPeople < ActiveRecord::Migration
  def change
    rename_column :people, :about_me, :about
  end
end
