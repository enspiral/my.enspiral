class ReconciliationService
  
  def self.get_external_accounts_from_xero(company)
    company.xero.Account.all(where: {type: 'BANK', status: 'ACTIVE'})
  end

  def self.create_external_accounts(company)
    external_accounts = get_external_accounts_from_xero(company)
    external_accounts.each do |account|
      ExternalAccount.find_or_create_by_external_id(account.account_id) do |a|
                                                    a.name = account.name.gsub(/[^a-z ]/i, ''),
                                                    a.company_id = company.id
      end
    end
  end

  def self.get_unreconciled_xero_transactions
    ExternalAccount.all.each do |account|
      company = account.company
      external_transactions = company.xero.BankTransaction.all(where: { is_reconciled: true, date_is_greater_than: DateTime.parse('2015-05-01'), type: 'SPEND'})
      external_transactions.each do |external_transaction|
        transactions = []
        transactions << company.xero.BankTransaction.find(external_transaction.bank_transaction_id)
        create_external_transactions(transactions)
      end
    end
  end

  def self.create_external_transactions(transactions)
    transactions.each do |transaction|
      external_account = ExternalAccount.where(external_id: transaction.bank_account.account_id).first
      ExternalTransaction.find_or_create_by_external_id(transaction.bank_transaction_id) do |t|
                                                        t.amount = transaction.total
                                                        t.contact = get_contact_for_external_transaction(transaction)
                                                        t.description = transaction.line_items.map(&:description).join(" | ")
                                                        t.date = transaction.date
                                                        t.external_account_id = external_account.id
      end
    end
  end

  def self.get_contact_for_external_transaction(transaction)
    if transaction.contact.present?
      if transaction.contact.name.present?
        transaction.contact.name
      else
        transaction.contact.id
      end
    else
      "N/A"
    end
  end
end
