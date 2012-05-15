class AccountHasOneCompany < ActiveRecord::Migration
  def change
    unless column_exists? :accounts, :company_id
      add_column :accounts, :company_id, :integer
    end
    Account.all.each do |account|
      if ac = AccountsCompany.where(account_id: account.id).first
        account.company_id = ac.company_id
        account.save!
      end
    end
    puts Account.where('company_id IS NULL').map{|a| a.name}
    change_column :accounts, :company_id, :integer, null: false
  end
end
