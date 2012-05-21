ENV["RAILS_ENV"] ||= 'test'
#require 'simplecov'

## Code coverage
#SimpleCov.start do
  #add_filter '/spec/'
  #add_filter '/config/'
  #add_filter '/lib/'
  #add_filter '/vendor/'

  #add_group 'Controllers', 'app/controllers'
  #add_group 'Models', 'app/models'
  #add_group 'Helpers', 'app/helpers'
  #add_group 'Mailers', 'app/mailers'
  #add_group 'Views', 'app/views'
#end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include Devise::TestHelpers, :type => :controller
  config.include AuthenticationHelper
  config.include MailerMacros

  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    reset_email 
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

RSpec.configure do |config|
  config.render_views
end
