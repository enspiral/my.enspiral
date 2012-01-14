begin
  
  namespace :enspiral do
    
    desc 'Get updated feeds from enspiral blog'
    task :get_updated_feeds => :environment do
      FeedEntry.get_updated_feeds
    end

    desc 'Mail all users their capacity for the next 5 weeks'
    task :mail_users_capacity_info => :environment do
      people = Person.where("default_hours_available IS NOT NULL")
      for person in people do
        Notifier.capacity_notification(person).deliver
      end
    end
    
  end
  
end
