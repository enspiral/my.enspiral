source 'http://rubygems.org'

# Core
gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'

# Database
gem 'mysql2'

# Templating and CSS
gem 'haml'
gem 'haml-rails'
gem 'sass-rails', :git => 'git://github.com/rails/sass-rails.git', :branch => '3-1-stable'
gem 'compass'
gem 'compass-less-plugin'

# Javascript
gem 'uglifier'
gem 'jquery-rails'
gem 'coffee-rails', :git => 'git://github.com/rails/coffee-rails.git', :branch => '3-1-stable'

# Helpers
gem 'devise' # Authentication
gem 'kaminari' # Pagination
gem 'carrierwave' # File uploads
gem 'mini_magick' # Resize images
gem 'gravtastic' # Gravatar images
gem 'RedCloth' # For Textile markup
gem 'feedzirra' # Pulling RSS data
gem 'whenever', :require => false # Deploying Cron jobs
# Notifications
gem 'hoptoad_notifier'
gem 'analytical'
gem 'rest-client', '1.6.3'


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
end

group :development, :test do
  # Debugging depending on the ruby you are running
  gem 'ruby-debug-base19', '0.11.23' if RUBY_VERSION.include? '1.9.1'
  gem 'ruby-debug19' if RUBY_VERSION.include? '1.9'
  gem 'rspec-rails'
  if defined?(Rubinius).nil? && RUBY_VERSION.include?('1.8')
    gem 'ruby-debug'
    gem 'linecache', '0.43'
  end

  # Opening webpages during tests
  gem 'launchy'

  # Testing Javascript
  gem 'jasmine', '~> 1.1.0.rc2'
end

group :test do
  # Core Testing
  gem 'rspec-rails'
  gem 'capybara', '~> 1.0.0'
  gem 'machinist', :git => 'git://github.com/notahat/machinist.git', :branch => 'master'
  
  # Test Helpers 
  gem 'database_cleaner'
  gem 'faker'
  gem 'steak'
  gem 'webrat'
  gem 'email_spec'
  gem 'shoulda', '~> 3.0.0.beta2'

  # Test coverage
  gem 'rcov', :require => false
  
  # Test feedback
  gem 'autotest'
  gem 'rspec-instafail', :require => false
  gem 'fuubar'
end

