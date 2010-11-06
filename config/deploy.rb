set :application, "enspiral"
set :user, application
set :repository,  "git@github.com:enspiral/enspiral.git"
set :scm, :git

set :deploy_via, :remote_cache
set :use_sudo, false

task :production do
  set :deploy_to, "/home/#{application}/production"
  set :branch, "production"
  set :rails_env, 'production'
end

task :staging do
  set :deploy_to, "/home/#{application}/staging"
  set :branch, "master"
  set :rails_env, 'staging'
end

role :app, "linode.enspiral.com"
role :web, "linode.enspiral.com"
role :db,  "linode.enspiral.com", :primary => true

namespace :deploy do
  # Using Phusion Passenger
  [:stop, :start, :restart].each do |task_name|
    task task_name, :roles => [:app] do
      run "cd #{current_path} && touch tmp/restart.txt"
    end 
  end 
  
  task :symlink_configs do
    run %( cd #{release_path} &&
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml 
    )
  end 
  
  desc "bundle gems"
  task :bundle do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} && bundle install #{shared_path}/gems/cache --deployment"
  end
end

after "deploy:update_code" do
  deploy.symlink_configs
  deploy.bundle
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
require 'whenever/capistrano'

set :whenever_command, 'bundle exec whenever'
