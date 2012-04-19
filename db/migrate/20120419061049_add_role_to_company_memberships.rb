class AddRoleToCompanyMemberships < ActiveRecord::Migration
  def change
    add_column :company_memberships, :role, :string
  end
end
