set :application, "enspiral"
set :user, application
set :repository,  "git@github.com:enspiral/enspiral.git"
set :scm, :git

set :deploy_to, "/home/#{application}/application"
set :deploy_via, :remote_cache
set :use_sudo, false

set :default_stage, "production"
require 'capistrano/ext/multistage'

role :app, "mars2.sinuous.net"
role :web, "mars2.sinuous.net"
role :db,  "mars2.sinuous.net", :primary => true

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
end

before "deploy:restart", "deploy:symlink_configs"



