class Invoice < ActiveRecord::Base
  belongs_to :customer

  has_many :allocations, :class_name => 'InvoiceAllocation'

end
