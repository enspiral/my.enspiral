class AddCompanyIdToClients < ActiveRecord::Migration
  def change
    add_column :customers, :company_id, :integer
  end
end
