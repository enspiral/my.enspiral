require 'spec_helper'

describe Blog do
  it 'should update feed items from valid feed_url' do
    @blog = Blog.make
    @blog.feed_url = 'http://blog.enspiral.com/feed/'
    @blog.save!
    feed_item = double("rss_item", title: "Title",
                                  url:"http://blog.enspiral.com/2012/05/15/the-hundred-year-company/", 
                                  published:"2012-05-15 10:24:06 UTC",
                                  author:"Will L.",
                                  categories:["Opinion", "Reflections", "Start-ups"],
                                  entry_id:"http://blog.enspiral.com/?p=703",
                                  summary:"I&rsquo;m a bit of a business geek. Ever since I threw in my Engineering job to try my hand starting my own web design business in the sexy dot.com age, and later",
                                  content:"<p style=\"text-align: center;\"><a href=\"http://blog.enspiral.com/wp-content/uploads/2012/05/100-year-old-company.jpg\"><img class=\"size-full wp-image-724 aligncenter\" title=\"100-year-old-company\" src=\"http://blog.enspiral.com/wp-content/uploads/2012/05/100-year-old-company.jpg\" alt=\"\" width=\"529\" height=\"447\"></a></p>"
                         ).as_null_object
    parser = double("feed_parser", title: 'Test Blog', url:'www.url.url', description: 'description', entries: [feed_item])

    Feedzirra::Feed.stub(:fetch_and_parse).and_return(parser)
    
    lambda {
      @blog.get_updated_posts
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
