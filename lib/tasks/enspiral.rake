begin
  namespace :enspiral do

    desc 'Update blog posts for all blogs'
    task :get_updated_blog_posts => :environment do
      Blog.all.each do |b|
        b.get_updated_posts
      end
    end

    desc 'Mail all users their capacity for the next 5 weeks'
    task :mail_users_capacity_info => :environment do
      Enspiral::CompanyNet::Person.active.each do |person|
        if person.projects.size > 0
          Notifier.capacity_notification(person).deliver
        end
      end
    end

    #legacy DELETE WHEN REMOVING OLD MARKETING.
    desc 'Get updated feeds from enspiral blog'
    task :get_updated_feeds => :environment do
      FeedEntry.get_updated_feeds
    end
  end
end
