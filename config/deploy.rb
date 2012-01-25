default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "enspiral"
set :repository,  "git@github.com:enspiral/#{application}.git"
set :user,        application 

set :use_sudo,    false

set :scm, :git

task :staging do
  set :domain,    "enspiral.info"
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
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    )
  end
end

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

  task :cleanup, :roles => :web do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:clean"
  end
end

after :deploy, "assets:precompile"

after "deploy:update_code" do
  deploy.symlink_configs
  deploy.bundle
end

require "./config/boot"
require "bundler/capistrano"
require "hoptoad_notifier/capistrano"
require "whenever/capistrano"

load 'deploy/assets'

set :whenever_command, "bundle exec whenever"

