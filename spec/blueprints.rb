require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  invoice_number { rand(20000) }
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
  number { Sham.invoice_number }
  amount {(rand(99) + 1) * 1000}
  paid { false }
  currency { "NZD" }
  date { rand(15).days.ago }
  due { rand(30).days.from_now }
end

InvoiceAllocation.blueprint do
  person { Person.make }
  invoice { Invoice.make }
  disbursed { false }
  currency { "NZD" }
end

def make_invoice_allocation
  make_invoice_allocation_for
end

def make_invoice_allocation_for invoice=nil, person=nil, proportion = 0.75
  invoice ||= Invoice.make
  person ||= Person.make
  allocation = InvoiceAllocation.new plan_invoice_allocation_for(invoice, person, proportion)
  allocation.save
  allocation
end

def plan_invoice_allocation_for invoice, person, proportion = 0.75
  InvoiceAllocation.plan(
    :invoice => invoice,
    :person => person,
    :amount => invoice.amount * proportion,
    :currency => invoice.currency
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

def make_person(role = nil)
 p = Person.make(role) 
 p.user.person = p
 p
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

Account.blueprint do
  person { Person.make }
end

Transaction.blueprint do
  account { Account.make }
  creator { Person.make }
  description { "this is a transaction" }
  amount { rand(5000) - 2500 }
  date { rand(15).days.ago }
end



