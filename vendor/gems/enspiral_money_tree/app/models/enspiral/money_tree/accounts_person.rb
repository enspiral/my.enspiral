module Enspiral
  module MoneyTree
    class AccountsPerson < ActiveRecord::Base
      belongs_to :person, class_name: 'Enspiral::CompanyNet::Person'
      belongs_to :account, class_name: 'Enspiral::MoneyTree::Account'
    end
  end
end
