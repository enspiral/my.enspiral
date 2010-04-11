class InvoiceAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :invoice
end
