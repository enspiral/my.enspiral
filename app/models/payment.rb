class Payment < ActiveRecord::Base
  belongs_to :invoice, inverse_of: :payments
  belongs_to :invoice_allocation
  belongs_to :author, class_name: 'Person'
  belongs_to :new_cash_transaction, dependent: :destroy, class_name: 'Transaction', dependent: :destroy
  belongs_to :renumeration_funds_transfer, class_name: 'FundsTransfer', dependent: :destroy
  belongs_to :contribution_funds_transfer, class_name: 'FundsTransfer', dependent: :destroy

  validates_presence_of :amount,
                        :paid_on,
                        :invoice_allocation,
                        :invoice,
                        :author


  validates_numericality_of :amount
  validate :amount_is_not_greater_than_allocation

  after_initialize do
    self.paid_on ||= Date.today
  end

  # I dont understand why these records are not being created
  # along with the Payment creation.. but the following does not
  # do the job i expected it to.. Which is why I've gone for the 
  # create or raise exception method below.. Which I like because
  # it causes transaction rollback on the whole lot.. but I don't
  # like because the validations will not propagate back when
  # the exception is not handled.
  # But I don't really see what can go wrong.. so yea.
  # 
  #before_create do
    #build_new_cash_transaction(
      #account: invoice.company.income_account,
      #amount: amount,
      #date: paid_on,
      #description: "payment for invoice_id #{invoice.id} from #{invoice.customer.name}")

    #build_renumeration_funds_transfer(
      #amount: renumeration_amount,
      #author: author,
      #description: renumeration_description,
      #source_account: invoice.company.income_account,
      #destination_account: invoice_allocation.account)

    #build_contribution_funds_transfer(
      #amount: contribution_amount,
      #author: author,
      #description: contribution_description,
      #source_account: invoice.company.income_account,
      #destination_account: invoice.company.support_account)
  #end

  after_create do
    create_new_cash_transaction!(account: invoice.company.income_account,
                                 amount: amount,
                                 date: paid_on,
                                 description: "payment for invoice_id #{invoice.id} from #{invoice.customer.name}")

    create_renumeration_funds_transfer!(
      amount: renumeration_amount,
      author: author,
      description: renumeration_description,
      source_account: invoice.company.income_account,
      destination_account: invoice_allocation.account) if renumeration_amount > 0

    create_contribution_funds_transfer!(
      amount: contribution_amount,
      author: author,
      description: contribution_description,
      source_account: invoice.company.income_account,
      destination_account: invoice.company.support_account) if contribution_amount > 0

    invoice.check_if_fully_paid(self)
    save!
  end

  def new_cash_description
    "Payment from #{invoice.customer.name} for invoice #{invoice.id}"
  end

  def renumeration_description
    "Payment from #{invoice.customer.name} for invoice #{invoice.id}"
  end

  def contribution_description
    "Contribution from #{invoice_allocation.account.name} for invoice #{invoice.id}"
  end

  def contribution_amount
    amount * invoice_allocation.contribution
  end

  def renumeration_amount
    amount - contribution_amount
  end

  private
  def amount_is_not_greater_than_allocation
    if invoice_allocation
      if amount > invoice_allocation.amount
        errors.add :amount, 'is greater than allocation'
      end
    end
  end

end
