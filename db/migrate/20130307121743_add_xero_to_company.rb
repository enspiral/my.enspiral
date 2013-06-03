class AddXeroToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :xero_consumer_key, :string
    add_column :companies, :xero_consumer_secret, :string
  end
end
