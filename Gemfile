source 'http://rubygems.org'


# Core
gem 'rails', '3.2.22'
gem 'i18n', '0.7.0'

# Database
gem 'pg', '~> 0.15.1'
gem 'mysql2'
gem 'thinking-sphinx', '2.0.10'


# Javascript
gem 'jquery-rails'
gem "rails-backbone"
gem "barista"

# Helpers
gem 'devise', '<2.1'
gem 'kaminari' # Pagination
gem 'mini_magick' # Resize images
gem 'gravtastic' # Gravatar images
gem 'feedjira' # Pulling RSS data
gem 'whenever', :require => false # Deploying Cron jobs
gem 'RedCloth'
gem 'html5-rails'
gem 'haml-rails'
gem 'simple_form'
gem 'cocoon'
gem 'wmd-rails'
gem 'bluecloth'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly', '~>0.9.12'
gem 'twitter'
gem 'will_paginate'
gem 'xeroizer',  :git => "git://github.com/waynerobinson/xeroizer.git"

# Notifications
gem 'airbrake', '3.1.15'
gem 'analytical'
gem 'rest-client', '>= 1.6.3'
gem 'therubyracer'
gem 'dynamic_form'

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'bootstrap-sass', '~> 2.0.4.0'
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
  gem 'haml_coffee_assets'
  gem 'haml_assets'
  gem 'kalendae_assets', '0.2.1'
  gem 'execjs'
end

group :development do
  # Better documentation
  gem 'tomdoc', :require => false

  # Testing emails
  gem 'mailcatcher', :require => false

  # Deployment
  gem 'capistrano', '2.15.5'
  gem 'capistrano-ext', :require => false
  gem 'capistrano-db-tasks', require: false

  # Helpful Rails Generators
  gem 'nifty-generators', '>= 0.4.4', :require => false

  gem 'guard-livereload'

  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'pry-rails'
  # Debugging depending on the ruby you are running
  gem 'hpricot'

  # Placed here so generators work
  gem 'rspec', '2.14.1'
  gem 'rspec-rails', '2.14.2'
  gem 'rb-readline', '~> 0.4.2'

  # Opening webpages during tests
  gem 'launchy'

  # Testing Javascript
  gem 'jasmine', '~> 1.1.0.rc2'
  # gem 'jasmine-headless-webkit', '~> 0.5.0'

  gem 'test-unit'
end

group :test do
  # Core Testing
  gem 'capybara', '>= 2.1.0'
  #gem "capybara-webkit", "~> 1.1.1"
  gem 'machinist', :git => 'git://github.com/notahat/machinist.git', :branch => 'master'
  gem 'cucumber-rails', :require => false
  gem 'poltergeist'
  
  # Test Helpers 
  gem 'database_cleaner'
  gem 'faker'
  gem 'timecop'
  gem 'steak'
  gem 'webrat'
  gem 'email_spec'
  gem 'shoulda', '~> 3.0.0.beta2'

  # Test coverage
  gem 'simplecov'
  
  # Test feedback
  #gem 'autotest'
  gem 'rspec-instafail', :require => false
end

group :staging do
 gem 'mail_safe'
end
