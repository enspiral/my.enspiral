class User < ActiveRecord::Base
  acts_as_authentic do |a|
    a.logged_in_timeout = 30.minutes
  end
end
