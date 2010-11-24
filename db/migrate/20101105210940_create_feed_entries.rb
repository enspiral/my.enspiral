class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string :feed_id
      t.string :title
      t.string :url
      t.string :author
      t.string :summary
      t.text :content
      t.timestamp :published
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
