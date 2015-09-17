class ExternalAccount < ActiveRecord::Base

  belongs_to  :company
  has_many    :external_transactions, dependent: :destroy

end
