load 'deploy/assets'

set :application, "enspiral"
set :repository,  "git@github.com:enspiral/#{application}.git"
set :user,        application 

set :use_sudo,    false

set :scm, :git

task :staging do
  set :domain,    "staging.enspiral.com"
  set :branch,    "staging"
  set :rails_env, "staging"
  set :deploy_to, "/home/#{user}/staging"
  
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

task :production do
  set :domain,    "enspiral.com"
  set :branch,    "production"
  set :rails_env, "production"
  set :deploy_to, "/home/#{user}/production"
  
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_configs do
    run %( cd #{release_path} &&
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
      ln -nfs #{shared_path}/assets #{release_path}/public/assets
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

