begin
  
  namespace :enspiral do

    desc 'Update blog posts for all blogs'
    task :get_updated_blog_posts => :environment do
      Blog.all.each do |b|
        b.get_updated_blog_posts
      end
    end

    desc 'Mail all users their capacity for the next 5 weeks'
    task :mail_users_capacity_info => :environment do
      people = Person.where("default_hours_available IS NOT NULL")
      for person in people do
        Notifier.capacity_notification(person).deliver
      end
    end

    #legacy DELETE WHEN REMOVING OLD MARKETING.
    desc 'Get updated feeds from enspiral blog'
    task :get_updated_feeds => :environment do
      FeedEntry.get_updated_feeds
    end
  end
end
