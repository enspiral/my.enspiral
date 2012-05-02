default_run_options[:pty] = true
ssh_options[:forward_agent] = true

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
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
      ln -nfs #{shared_path}/config/production.sphinx.conf #{release_path}/config/#{branch}.sphinx.conf
    )
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end

  desc "Activate Sphinx"
  task :activate_sphinx, :roles => [:app] do
    symlink_sphinx_indexes
    thinking_sphinx.start
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

before 'deploy', 'thinking_sphinx:stop'
after 'deploy', 'deploy:activate_sphinx'
after 'deploy:migrations', 'deploy:activate_sphinx'
after :deploy, "assets:precompile"
after "deploy:update_code" do
  deploy.symlink_configs
  deploy.bundle
end



require "./config/boot"
require "bundler/capistrano"

require "whenever/capistrano"
require 'airbrake/capistrano'

#load 'deploy/assets'

require 'thinking_sphinx/deploy/capistrano'


namespace :thinking_sphinx do
  def rake(*tasks)
    rails_env = fetch(:rails_env, "production")
    rake = fetch(:rake, "rake")
    tasks.each do |t|
      run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
    end
  end
   
  task :stop do
    rake "thinking_sphinx:stop"
  end
  
  task :start do
    rake "thinking_sphinx:start"
  end
  
  task :restart do
    rake "thinking_sphinx:stop thinking_sphinx:start"
  end

  task :rebuild do
    run "ln -nfs #{shared_path}/config/production.sphinx.conf #{release_path}/config/#{branch}.sphinx.conf"
    stop
    index
    start
  end
  
  task :index do
    run "cd #{current_path} && /usr/local/bin/indexer --config /home/crackers/staging/current/config/staging.sphinx.conf --all --rotate"    
  end
  
  task :reindex do
    run "cd #{current_path} && /usr/local/bin/indexer --config /home/crackers/staging/current/config/staging.sphinx.conf --all --rotate"    
  end
end

set :whenever_command, "bundle exec whenever"
