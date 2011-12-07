class Customer < ActiveRecord::Base
  default_scope order(:name)
end
