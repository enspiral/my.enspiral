begin
  
  namespace :enspiral do
    
    desc 'Get updated feeds from enspiral blog'
    task :get_updated_feeds => :environment do
      FeedEntry.get_updated_feeds
    end
    
  end
  
end