class AccountsPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :account, class_name: "Enspiral::MoneyTree::Account"
end
