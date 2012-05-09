class AddMarketingFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :blog_feed_url, :string
    add_column :people, :facebook, :string
    add_column :people, :linkedin, :string
    add_column :people, :published, :boolean
  end
end
