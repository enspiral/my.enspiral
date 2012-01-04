class AddIsLeadAndRoleToProjectMemberships < ActiveRecord::Migration
  def change
    add_column :project_memberships, :is_lead, :boolean
    add_column :project_memberships, :role, :string
  end
end
