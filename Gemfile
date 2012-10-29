source 'http://rubygems.org'


# Core
gem 'rails', '3.2.8'

# Database
gem 'pg'
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
gem 'feedzirra' # Pulling RSS data
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

# Notifications
gem 'airbrake'
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
  gem 'kalendae_assets'
  gem 'execjs'
end


group :development do
  # Better documentation
  gem 'tomdoc', :require => false

  # Testing emails
  gem 'mailcatcher', :require => false

  # Deployment
  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false

  # Helpful Rails Generators
  gem 'nifty-generators', '>= 0.4.4', :require => false

  gem 'guard-livereload'
end

group :development, :test do
  # Debugging depending on the ruby you are running
  gem 'hpricot'

  # Automatic testing
  gem 'guard'
  gem 'guard-rspec'

  # Placed here so generators work
  gem 'rspec'
  gem 'rspec-rails'

  # Opening webpages during tests
  gem 'launchy'

  # Testing Javascript
  gem 'jasmine', '~> 1.1.0.rc2'
  gem 'jasmine-headless-webkit'

  gem 'test-unit'
end

group :test do
  # Core Testing
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'machinist', :git => 'git://github.com/notahat/machinist.git', :branch => 'master'
  gem 'cucumber-rails', :require => false
  
  # Test Helpers 
  gem 'database_cleaner'
  gem 'faker'
  gem 'timecop'
  gem 'steak'
  gem 'webrat'
  gem 'email_spec'
  gem 'shoulda', '~> 3.0.0.beta2'
  gem 'guard-rspec'

  # Test coverage
  gem 'simplecov'
  
  # Test feedback
  gem 'autotest'
  gem 'rspec-instafail', :require => false
  gem 'fuubar'
end

group :staging do
 gem 'mail_safe'
end
