class CreateFundsTransferTemplates < ActiveRecord::Migration
  def change
    create_table :funds_transfer_templates do |t|
      t.string :name
      t.string :description
      t.integer :company_id

      t.timestamps
    end
    add_index :funds_transfer_templates, :company_id
  end
end
