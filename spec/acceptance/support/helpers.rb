module HelperMethods
  RSpec.configure do |config|
    config.before(:each) do
      Machinist.reset_before_test
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
