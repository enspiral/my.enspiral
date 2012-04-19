class Customer < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company
  default_scope order(:name)
end
