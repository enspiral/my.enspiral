class Blog < ActiveRecord::Base
  attr_accessible :company_id, :feed_url, :person_id, :url
  belongs_to :person
  belongs_to :company
  has_many :blog_posts

  def get_updated_posts
    latest_post = blog_posts.order('posted_at desc').first
    options = {}
    options[:if_modified_since] = latest_post.posted_at unless latest_post.blank?
    
    feed = Feedzirra::Feed.fetch_and_parse feed_url, options
    
    return unless feed.respond_to?(:entries)
    
    feed.entries.each do |entry|
      entry.sanitize!
      BlogPost.create :blog_id => self.id,
                  :post_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :posted_at => entry.published
    end
  end
end
