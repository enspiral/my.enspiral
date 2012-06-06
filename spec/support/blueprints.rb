require 'machinist/active_record'

Customer.blueprint do
  company
  name { Faker::Company.name }
end

Invoice.blueprint do
  customer
  company
  number { rand(20000) }
  amount {(rand(99) + 1) * 1000}
  paid { false }
  currency { "NZD" }
  date { rand(15).days.ago }
  due { rand(30).days.from_now }
end

InvoiceAllocation.blueprint do
  disbursed { false }
  currency { "NZD" }
  amount { 1 }
  account
  invoice
end

Person.blueprint do
  email { Faker::Internet.email }
  user
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end

Person.blueprint(:admin) do
  last_name { Faker::Name.last_name + " (admin)" }
  user { User.make(:admin) }
end

Person.blueprint(:staff) do
  last_name { Faker::Name.last_name + " (staff)" }
  user { User.make(:staff) }
end

Project.blueprint do
  name { "my project" }
  customer
end

User.blueprint do
  email { Faker::Internet.email }
  role {"staff"}
  password { 'secret' }
  password_confirmation { 'secret' }
end

User.blueprint(:admin) do
  role {"admin"}
end

User.blueprint(:staff) do
  role {"staff"}
end

Account.blueprint do
  name {Faker::name}
  company
  active {true}
  closed {false}
  min_balance {0}
end

Account.blueprint(:project) do
end

Transaction.blueprint do
  description { "this is a transaction" }
  amount { rand(5000) - 2500 }
  date { rand(15).days.ago }
  account
  creator
end

Notice.blueprint do
  summary { 'this is a summary' }
  text { 'this is a text' }
  person
end

Comment.blueprint do
  text { 'this is a text'}
  commentable { Notice.make }
  person
end

Comment.blueprint(:comment) do
  text { 'this is a text'}
  commentable { Comment.make }
  person
end


Country.blueprint do
  name { Faker::Lorem.words.join ' ' }
end


City.blueprint do
  country
  name { Faker::Lorem.words.join ' ' }
end


Skill.blueprint do
  description {Faker::Lorem.word(2)}
end

Project.blueprint do
  company
  customer
  status { 'active' }
  name { Faker::Company.name }
end

ProjectBooking.blueprint do
  project_membership
  week { Date.today }
  time { 48 }
end

ProjectMembership.blueprint do
  person
  project
end

AccountsPerson.blueprint do
  # Attributes here
end

FundsTransfer.blueprint do
  # Attributes here
end

Company.blueprint do
  # Attributes here
  name {Faker::Company.name}
  default_contribution { 0.02 }
end

CompanyMembership.blueprint do
  # Attributes here
end

AccountsCompany.blueprint do
  # Attributes here
end

Payment.blueprint do
  # Attributes here
end

Group.blueprint do
  # Attributes here
end

PeopleGroup.blueprint do
  # Attributes here
end

FeaturedItem.blueprint do
  resource {Person.make!}
end

Blog.blueprint do
  person
  url {Faker::Internet.domain_name}
end

BlogPost.blueprint do
  # Attributes here
end

FundsTransferTemplate.blueprint do
  # Attributes here
  name {'template'}
  description {'descripion'}

end

FundsTransferTemplateLine.blueprint do
  # Attributes here
end
