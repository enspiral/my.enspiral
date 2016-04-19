class Payment < ActiveRecord::Base
  include ApplicationHelper

  include Rails.application.routes.url_helpers
  belongs_to :invoice, inverse_of: :payments
  belongs_to :invoice_allocation
  belongs_to :author, class_name: 'Person'
  belongs_to :new_cash_transaction, class_name: 'Transaction'
  belongs_to :renumeration_funds_transfer, class_name: 'FundsTransfer', inverse_of: :payment
  belongs_to :contribution_funds_transfer, class_name: 'FundsTransfer', inverse_of: :payment

  validates_presence_of :amount,
                        :paid_on,
                        :invoice_allocation,
                        :invoice,
                        :author


  validates_numericality_of :amount
  validate :amount_is_not_greater_than_allocation

  after_initialize do
    target_date = invoice && invoice.company ? today_in_zone(invoice.company) : Date.today
    self.paid_on ||= target_date
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
      amount: remuneration_amount,
      author: author,
      description: renumeration_description,
      source_account: invoice.company.income_account,
      destination_account: invoice_allocation.account) if remuneration_amount > 0

    if invoice_allocation.team_account_id
      contribution_team_amount = contribution_amount / 8.0
      contribution_support_amount = contribution_amount - contribution_team_amount

      create_contribution_funds_transfer!(
      amount: contribution_team_amount,
      author: author,
      description: contribution_description,
      source_account: invoice.company.income_account,
      destination_account: Account.find(invoice_allocation.team_account_id)) if contribution_amount > 0

      create_contribution_funds_transfer!(
      amount: contribution_support_amount,
      author: author,
      description: contribution_description,
      source_account: invoice.company.income_account,
      destination_account: invoice.company.support_account) if contribution_amount > 0

    else
      create_contribution_funds_transfer!(
        amount: contribution_amount,
        author: author,
        description: contribution_description,
        source_account: invoice.company.income_account,
        destination_account: invoice.company.support_account) if contribution_amount > 0
    end


    invoice.check_if_fully_paid(self)
    save!
  end

  def reverse
    contribution_amount = self.amount * invoice_allocation.contribution
    raise "Cannot reverse transaction - insufficient funds" unless can_reverse?
    if invoice_allocation.team_account_id
      contribution_team_amount = contribution_amount / 8.0
      contribution_support_amount = contribution_amount - contribution_team_amount
      team_account = Account.find(invoice_allocation.team_account_id)

      team_account.reverse_payment contribution_team_amount
      invoice_allocation.account.company.support_account.reverse_payment contribution_support_amount
    else
      invoice_allocation.account.company.support_account.reverse_payment contribution_amount
    end
    invoice_allocation.account.reverse_payment remuneration_amount
    self.destroy
  end

  def can_reverse?
    transaction = invoice_allocation.account.transactions.new(amount: -remuneration_amount, description: "reverse payment from account #{invoice_allocation.name}", date: Time.now)
    transaction.valid?
  end

  def new_cash_description
    "Payment from #{invoice.customer.name} for <a href=#{company_invoice_path(1, invoice.id)}> invoice #{invoice.id}</a> / Xero: #{invoice.xero_reference}"
  end

  def renumeration_description
    "Payment from #{invoice.customer.name} for <a href=#{company_invoice_path(1, invoice.id)}> invoice #{invoice.id}</a> / Xero: #{invoice.xero_reference}"
  end

  def contribution_description
    "Contribution from #{invoice_allocation.account.name} for <a href=#{company_invoice_path(1, invoice.id)}> invoice #{invoice.id} </a> /  Xero: #{invoice.xero_reference}"
  end

  private

  def contribution_amount
    amount * invoice_allocation.contribution
  end

  def remuneration_amount
    amount - amount * invoice_allocation.contribution
  end

  def amount_is_not_greater_than_allocation
    if invoice_allocation
      if amount > invoice_allocation.amount
        errors.add :amount, 'is greater than allocation'
      end
    end
  end

end
