class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :title
      t.integer :for_id
      t.string :for_type
      t.integer :file_uid
      t.string :file_name
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
    create_table :contract_parties do |cp|
      cp.integer :contract_id
      cp.integer :contractable_id
      cp.string :contractable_type

      cp.timestamps
    end
  end
end
