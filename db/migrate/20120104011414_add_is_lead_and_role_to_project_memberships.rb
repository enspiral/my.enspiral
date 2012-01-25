class AddIsLeadAndRoleToProjectMemberships < ActiveRecord::Migration
  def change
    add_column :project_memberships, :is_lead, :boolean
    add_column :project_memberships, :role, :string
    add_index :project_memberships, [:project_id, :person_id], :unique => true
    add_index :project_bookings, [:project_membership_id, :week], :unique => true
  end
end
