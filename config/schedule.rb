# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, {:error => '/home/enspiral/production/shared/log/cron.log', :standard => '/home/enspiral/production/shared/log/cron.log'}

every 30.minutes do
  rake 'enspiral:get_updated_feeds'
end

every 10.minutes do
  #update sphinx index
  rake "thinking_sphinx:index" 
end

every 30.minutes do
  rake 'enspiral:get_updated_blog_posts'
end

#every :sunday, :at => '12pm' do
#  rake 'enspiral:mail_users_capacity_info'
#end
