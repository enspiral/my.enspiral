class CreateExternalAccounts < ActiveRecord::Migration
  def change
    create_table :external_accounts do |t|
      t.string      :external_id, null: false
      t.string      :name, null: false
      t.belongs_to  :company, index: true, null: false
      t.integer     :default_account_id

      t.timestamps
    end
  end
end
