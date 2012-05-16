class AddPostIdToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :post_id, :string
  end
end
