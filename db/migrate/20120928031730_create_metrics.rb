class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.references :company
      t.date :for_date
      t.decimal :revenue, :precision => 8, :scale => 2
      t.integer :people
      t.integer :active_users

      t.timestamps
    end
    add_index :metrics, :company_id
  end
end
