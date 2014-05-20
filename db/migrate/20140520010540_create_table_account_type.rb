class CreateTableAccountType < ActiveRecord::Migration
  def change
    create_table :account_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
