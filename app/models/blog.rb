class Blog < ActiveRecord::Base
  attr_accessible :company_id, :feed_url, :person_id, :url
  belongs_to :person
  belongs_to :company
  has_many :blog_posts

  def get_updated_posts
    options = {}
    puts "************************"
    puts blog_posts.first.inspect
    if blog_posts.first then options[:if_modified_since] = blog_posts.first.posted_at  end
    
    feed = Feedzirra::Feed.fetch_and_parse feed_url, options
    
    return unless feed.respond_to?(:entries)
    
    feed.entries.each do |entry|
      entry.sanitize!
      blog_posts.create :post_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :posted_at => entry.published
    end
  end
end
