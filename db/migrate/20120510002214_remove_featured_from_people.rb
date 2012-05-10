class RemoveFeaturedFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :featured
  end
end
