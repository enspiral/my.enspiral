class AccountsCompany < ActiveRecord::Base
  belongs_to :company
  belongs_to :account
end
