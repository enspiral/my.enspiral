class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.references :company
      t.date :for_date
      t.decimal :internal_revenue, :precision => 12, :scale => 2
      t.decimal :external_revenue, :precision => 12, :scale => 2
      t.integer :people
      t.integer :active_users

      t.timestamps
    end
    add_index :metrics, :company_id
  end
end
