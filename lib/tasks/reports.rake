begin

  namespace :reports do
    desc "print pay by month"
    task :pay => :environment do
      pay = Account.find_by_name "Pay"
      taxes = Account.find_by_name "Taxes"
      (1..12).each do |i|
        d = Date.parse "2014-#{i}-01"
        end_of_last_month = d - 1.day
        pay_amount = pay.balance_at(d.end_of_month) - pay.balance_at(end_of_last_month)
        tax_amount = taxes.balance_at(d.end_of_month) - taxes.balance_at(end_of_last_month)
        amount = pay_amount + tax_amount
        puts "#{d} - #{amount}"
      end
    end

    desc "print transactions on pay account"
    task :transactions => :environment do
      acc = Account.find_by_name "TEAM: Craftworks"
      d = Date.parse "2014-03-01"
      d2 = Date.parse "2014-12-01"
      transfers = FundsTransfer.where("date >= ? AND date <= ? AND source_account_id = ?", d, d.end_of_month, acc.id).order :date

      #transfers = FundsTransfer.where("date >= ? AND date <= ? AND destination_account_id = ? AND source_account_id = 2", d, d2, pay.id).order :date
      transfers.each do |t|
        puts "#{t.date},#{t.amount},#{t.source_account.name},#{t.destination_account.name},#{t.description}"
      end
      transactions = Transaction.where("date >= ? AND date <= ? AND account_id = ?", d, d.end_of_month, acc.id).order :date
      transactions.each do |t|
        puts "#{t.date},#{t.amount},#{t.description}"
      end
      sum = transfers.inject(0) {|sum, t| sum += t.amount}
      puts "#{transfers.count} Transfers worth #{sum}"

      sum = transactions.inject(0) {|sum, t| sum += t.amount}
      puts "#{transactions.count} Transactions worth #{sum}"
    end
    
    desc "sales totals" 
    task :sales_totals => :environment do
      sales = Account.find_by_name "Sales Income"
      (1..12).each do |i|
        d = Date.parse "2014-#{i}-01"
        end_of_last_month = d - 1.day
        amount = sales.balance_at(d.end_of_month) - sales.balance_at(end_of_last_month)
        puts "#{d},#{amount}"
      end
    end

    desc "contributions"
    task :contributions => :environment do
      type = AccountType.find_by_name 'Team'
      team_accounts = type.accounts.where(company_id: 1).all
      collective_account = Account.find_by_name 'Collective Funds'
      sales_account = Account.find_by_name 'Sales Income'
      craftworks = Account.find 351
      accounts = [collective_account] + team_accounts
      #accounts = [collective_account, craftworks]
      total_sales = 0
      total_payments = 0
      total_reversals = 0
      total_contributions = 0
      (1..12).each do |i|
        d = Date.parse "2014-#{i}-01"
        end_of_last_month = d - 1.day
        puts d
        sales = sales_account.transactions.where("date <= ? AND date >= ? AND amount > 0", d.end_of_month, end_of_last_month).sum('amount')
        staff_payments = Transaction.where("date <= ? AND date >= ? AND description LIKE '%Payment from%' AND amount > 0", d.end_of_month, end_of_last_month).sum('amount')
        staff_reversals = Transaction.where("date <= ? AND date >= ? AND description LIKE '%reverse payment%' AND account_id NOT IN (?)", d.end_of_month, end_of_last_month, accounts.map(&:id)).sum('amount')
        puts "sales, #{sales}"
        puts "staff payments, #{staff_payments}"
        puts "staff reversals, #{staff_reversals}"
        total_sales += sales
        total_payments += staff_payments
        total_reversals += staff_reversals
        accounts.each do |acc|
          amount = acc.transactions.where("date <= ? AND date >= ? AND description LIKE '%Contribution%'", d.end_of_month, end_of_last_month).sum('amount')
          puts "#{acc.name} Contributions,#{amount}" if amount > 0
          total_contributions += amount
          amount = acc.transactions.where("date <= ? AND date >= ? AND description LIKE '%reverse payment%'", d.end_of_month, end_of_last_month).sum('amount')
          puts "#{acc.name} Reversals,#{amount}" if amount < 0
          total_reversals += amount
        end
      end
      puts "total sales, #{total_sales}"
      puts "total payments, #{total_payments}"
      puts "total contributions, #{total_contributions}"
      puts "total reversals, #{total_reversals}"
    end
  end
end
