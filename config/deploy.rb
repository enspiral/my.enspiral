set :application, "enspiral"
set :user,        application 
set :repository,  "git@github.com:enspiral/#{application}.git"
set :scm,         :git

set :deploy_via,  :remote_cache
set :use_sudo,    false

task :staging do
  set :domain,    "staging.enspiral.com"
  set :branch,    "staging"
  set :rails_env, "staging"
  set :deploy_to, "/home/#{user}/staging"
  
  role :app, domain
  role :web, domain
  role :db,  domain, :primary => true
end

task :production do
  set :domain,    "enspiral.com"
  set :branch,    "production"
  set :rails_env, "production"
  set :deploy_to, "/home/#{user}/production"
  
  role :app, domain
  role :web, domain
  role :db,  domain, :primary => true
end

namespace :deploy do
  [:stop, :start, :restart].each do |task_name|
    desc "Touch restart.txt so server is restarted."
    task task_name, :roles => [:app] do
      run "cd #{current_path} && touch tmp/restart.txt"
    end 
  end

  desc "Make system links"
  task :symlink_configs do
    run %( cd #{release_path} &&
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    )
  end
end

after "deploy:update_code" do
  deploy.symlink_configs
  deploy.bundle
end

require "./config/boot"
require "bundler/capistrano"
require "hoptoad_notifier/capistrano"
require "whenever/capistrano"

set :whenever_command, "bundle exec whenever"

