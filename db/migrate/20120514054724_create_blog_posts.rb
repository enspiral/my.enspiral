class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :blog_id
      t.string :title
      t.string :author
      t.text :summary
      t.string :url
      t.timestamp :posted_at
      t.text :content

      t.timestamps
    end
  end
end
