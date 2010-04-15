class Invoice < ActiveRecord::Base
  belongs_to :customer

  has_many :allocations, :class_name => 'InvoiceAllocation'

  def mark_as_paid
    allocations.each do |a|
      a.disburse
    end
    update_attribute(:paid, true)
  end

end
