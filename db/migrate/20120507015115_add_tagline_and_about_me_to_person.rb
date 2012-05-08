class AddTaglineAndAboutMeToPerson < ActiveRecord::Migration
  def change
    add_column :people, :about_me, :text
    add_column :people, :tagline, :string
  end
end
