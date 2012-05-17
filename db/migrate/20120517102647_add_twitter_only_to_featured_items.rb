class AddTwitterOnlyToFeaturedItems < ActiveRecord::Migration
  def change
    add_column :featured_items, :twitter_only, :boolean, default: false
  end
end
