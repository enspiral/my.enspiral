class FeedEntry < ActiveRecord::Base
  
  validates_uniqueness_of :feed_id
  
  scope :latest, lambda { order('published desc').limit(3) }
  
  def self.get_updated_feeds
    latest_feed = self.order('published desc').first
    options = {}
    options[:if_modified_since] = latest_feed.published unless latest_feed.blank?
    
    feed = Feedzirra::Feed.fetch_and_parse 'http://blog.enspiral.com/category/enspiral/feed', options
    
    return unless feed.respond_to?(:entries)
    
    feed.entries.each do |entry|
      entry.sanitize!
      self.create :feed_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :published => entry.published
    end
  end
  
end
