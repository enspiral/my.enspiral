class ExternalTransaction < ActiveRecord::Base

  scope :unreconciled, -> { where(funds_transfer_id: nil) }
  scope :reconciled, -> { where('funds_transfer_id IS NOT NULL') }

  belongs_to  :external_account
  belongs_to  :person
  belongs_to  :funds_transfer

  def reconciled_at
    if funds_transfer
      funds_transfer.created_at
    else
      nil
    end
  end
end
