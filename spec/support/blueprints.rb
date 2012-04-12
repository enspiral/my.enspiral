require 'machinist/active_record'

Customer.blueprint do
  name { Faker::Company.name }
end

Invoice.blueprint do
  customer { Customer.make! }
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
  account { Account.make! }
  invoice { Invoice.make! }
end

Person.blueprint do
  email { Faker::Internet.email }
  user {User.make!}
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
#  person
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
  person 
end

Account.blueprint(:project) do
  project 
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

ServiceCategory.blueprint do
  name { Faker::Lorem.words.join ' ' }
end

Country.blueprint do
  name { Faker::Lorem.words.join ' ' }
end

Service.blueprint do
  person
  service_category
  description { Faker::Lorem.words.join ' ' }
  rate { rand(100) }
end

City.blueprint do
  country
  name { Faker::Lorem.words.join ' ' }
end

Badge.blueprint do
  name { Faker::Lorem.words.join ' ' } 
  image { File.open("#{Rails.root}/spec/support/images/rails.png") }
end

BadgeOwnership.blueprint do
  badge { Badge.make }
  user { User.make(:person => Person.make) }
  person { Person.make }
  reason { Faker::Lorem.words.join ' ' }
end

Goal.blueprint do
  person { Person.make }
  title { Faker::Lorem.words.join ' ' } 
  date { rand(15).days.ago }
  score { 0 }
end

Skill.blueprint do
  description {Faker::Lorem.word(2)}
end

Project.blueprint do
  customer { Customer.make! }
  status { 'active' }
  name { Faker::Company.name }
end

ProjectBooking.blueprint do
  project_membership { ProjectMembership.make! }
  week { Date.today }
  time { 48 }
end

ProjectMembership.blueprint do
  person { Person.make! }
  project { Project.make! }
end

AccountPermission.blueprint do
  # Attributes here
end
