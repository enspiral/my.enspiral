class AddFieldsToPersons < ActiveRecord::Migration
  def change
    add_column :people, :relationship_with_enspiral, :string
    add_column :people, :employment_status, :string
    add_column :people, :desired_employment_status, :string
    add_column :people, :baseline_income, :integer
    add_column :people, :ideal_income, :integer
  end
end
