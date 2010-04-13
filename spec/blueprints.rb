require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  company { Faker::Company.name }
  email { Faker::Internet.email }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  coin_toss(:unique => false) { rand(2) == 0 }
end

Customer.blueprint do
  name { Sham.company }
end

Invoice.blueprint do
  customer { Customer.make } 
  amount {(rand(99) + 1) * 1000}
  paid { Sham.coin_toss }
  currency { "NZD" }
  date { rand(15).days.ago }
  due { rand(30).days.from_now }
end

InvoiceAllocation.blueprint do
  person { Person.make }
  invoice { Invoice.make }
end

def make_invoice_allocation_for invoice, proportion = 0.75
  invoice = plan_invoice_allocation_for(invoice, proportion)
  invoice.save
end

def plan_invoice_allocation_for invoice, proportion = 0.75
  InvoiceAllocation.plan(
    :invoice => invoice,
    :amount => invoice.amount * proportion,
    :currency => invoice.currency,
    :disbursed => false
  )
end

Person.blueprint do
  first_name
  last_name
  email
  user {User.make}
end

Person.blueprint(:admin) do
  last_name { Sham.last_name + " (admin)" }
  user { User.make(:admin) }
end

User.blueprint do
  email
  role {"staff"}
  password 'secret'
  password_confirmation { password }
end

User.blueprint(:admin) do
  role {"admin"}
end



