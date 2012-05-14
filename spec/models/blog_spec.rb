require 'spec_helper'

describe Blog do
  it 'should update feed items from valid feed_url' do
    @blog = Blog.make
    @blog.feed_url = 'http://blog.enspiral.com/feed/'
    @blog.save!

    lambda {
      feed = Feedzirra::Feed.fetch_and_parse @blog.feed_url
      
      return unless feed.respond_to?(:entries)
      
      entry = feed.entries.first
      entry.sanitize!
      BlogPost.create :blog_id => @blog.id,
                  :post_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :posted_at => entry.published
    }.should change(BlogPost, :count).by(1)
  end

  it 'should not create duplicate blog post items' do
    @blog = Blog.make
    @blog.feed_url = 'http://blog.enspiral.com/feed/'
    @blog.save!

    lambda {
      feed = Feedzirra::Feed.fetch_and_parse @blog.feed_url
      
      return unless feed.respond_to?(:entries)
      
      entry = feed.entries.first
      entry.sanitize!
      BlogPost.create :blog_id => @blog.id,
                  :post_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :posted_at => entry.published
      BlogPost.create :blog_id => @blog.id,
                  :post_id => entry.id,
                  :title => entry.title,
                  :url => entry.url,
                  :author => entry.author,
                  :summary => entry.summary,
                  :content => entry.content,
                  :posted_at => entry.published
    }.should change(BlogPost, :count).by(1)
  end

  it 'should not update blog posts from invalid feed_url' do
    @blog = Blog.make
    @blog.feed_url = 'invalid'
    @blog.save!
    lambda {
      @blog.get_updated_posts
    }.should_not change(BlogPost, :count)
  end
end
