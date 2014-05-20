# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#User.delete_all
#Account.delete_all
#Person.delete_all
#
#account = Account.create!
#
#daley_thompson = User.create!(
#  :account  => account,
#  :name     => "Daley Thompson (Staff)",
#  :role     => "staff",
#  :username => "daley.thompson",
#  :password => "password"
#)
#
#Person.create! :email => "xxx@xxx.com", :user => daley_thompson

AccountType.find_or_create_by_name("Staff")
AccountType.find_or_create_by_name("Bucket")
AccountType.find_or_create_by_name("Tax Paid")
AccountType.find_or_create_by_name("Collective Funds")
AccountType.find_or_create_by_name("Team")
