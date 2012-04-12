class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies, :force => true do |t|
      t.string :name
      t.integer :income_account_id
      t.integer :support_account_id
      t.integer :default_commission

      t.timestamps
    end
  end
end
