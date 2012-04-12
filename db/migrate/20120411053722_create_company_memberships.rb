class CreateCompanyMemberships < ActiveRecord::Migration
  def change
    create_table :company_memberships, :force => true do |t|
      t.integer :company_id
      t.integer :person_id
      t.boolean :admin

      t.timestamps
    end
    add_index :company_memberships, :company_id
    add_index :company_memberships, :person_id
  end
end
