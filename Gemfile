source 'http://rubygems.org'

gem 'rails', '~> 3.0.7'
gem 'rake', '~> 0.8.7'
gem 'mysql2', '~> 0.2.7'

gem 'devise'
gem 'hpricot'
gem 'ruby_parser'

gem 'haml'
gem 'haml-rails'
gem 'compass'
gem 'compass-less-plugin'

gem 'will_paginate', '>= 3.0.pre2'
gem 'paperclip'
gem 'gravtastic'
gem 'RedCloth'
gem 'jquery-rails'
gem 'ruby_parser'
gem 'feedzirra'
gem 'whenever', :require => false

gem 'hoptoad_notifier'

group :development do
  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
  gem 'nifty-generators', '>= 0.4.4', :require => false
end

group :test, :development do
  gem 'rspec-rails'
  gem 'steak'
  gem 'capybara'
  gem 'webrat'
  gem 'database_cleaner'
  gem 'spork'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'faker'
  gem 'email_spec'
  gem 'autotest'
  gem 'launchy'
  gem 'shoulda'
  
  gem 'ruby-debug-base19', '0.11.23' if RUBY_VERSION.include? '1.9.1'
  gem 'ruby-debug' if defined?(Rubinius).nil? && RUBY_VERSION.include?('1.8')
  gem 'ruby-debug19' if RUBY_VERSION.include? '1.9'
end

