class CreateFundsTransferTemplateLines < ActiveRecord::Migration
  def change
    create_table :funds_transfer_template_lines do |t|
      t.integer :funds_transfer_template_id
      t.integer :source_account_id
      t.integer :destination_account_id
      t.decimal :amount

      t.timestamps
    end
    add_index :funds_transfer_template_lines, :funds_transfer_template_id, name: 'fttlftt_id'
  end
end
