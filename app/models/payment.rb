class Payment < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :author, :class_name => 'Person'
  belongs_to :transaction, :dependent => :destroy
  validates_presence_of :amount, :invoice, :paid_on

  after_create do
    create_transaction(account: invoice.company.income_account,
                       amount: amount,
                       date: paid_on,
                       description: "invoice_id #{invoice.id}, payment_id #{id}, from #{invoice.customer.name}")

    save!
  end
end
