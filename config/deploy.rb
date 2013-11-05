default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "enspiral"
set :repository,  "git@github.com:enspiral/#{application}.git"
set :user,        application 
set :rake, "bundle exec rake"


set :use_sudo,    false

set :scm, :git

task :staging do
  set :domain,    "staging.enspiral.com"
  set :branch,    "allan"
  set :rails_env, "staging"
  set :deploy_to, "/home/#{user}/staging"

  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

task :production do
  set :domain,    "my.enspiral.com"
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

namespace :dragonfly do
  desc "Symlink the Rack::Cache files"
  task :symlink, :roles => [:app] do
    run "mkdir -p #{shared_path}/tmp/dragonfly && ln -nfs #{shared_path}/tmp/dragonfly #{release_path}/tmp/dragonfly"
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

after 'deploy:update_code' do
  deploy.symlink_configs
  thinking_sphinx.stop
  thinking_sphinx.start
  dragonfly.symlink
end

namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
end

after 'deploy:finalize_update', 'sphinx:symlink_indexes'
set :whenever_command, "bundle exec whenever"

require "./config/boot"
require "bundler/capistrano"

require "whenever/capistrano"
require 'airbrake/capistrano'

load 'deploy/assets'

require 'thinking_sphinx/deploy/capistrano'

