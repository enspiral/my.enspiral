class CreateXeroImportLog < ActiveRecord::Migration
  def up
    create_table :xero_import_log do |t|
      t.integer :company_id, null: false
      t.datetime :performed_at, null: false
      t.integer :performed_by
      t.integer :number_of_invoices, null: false, default: 0
      t.integer :number_of_errors, null: false, default: 0
      t.text :invoices_with_errors

      t.timestamps null: false
    end

  end

  def down
    drop_table :xero_import_log
  end
end
