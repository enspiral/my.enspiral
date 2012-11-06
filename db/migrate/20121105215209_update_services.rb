class UpdateServices < ActiveRecord::Migration
  def up
    Service.destroy_all
    drop_table :service_categories
    remove_column :services, :service_category_id
    remove_column :services, :rate
    remove_column :services, :person_id
    add_column :services, :name, :string
    add_column :services, :image_uid, :string
  end

  def down
    create_table :service_categories do |t|
      t.string :name
      t.timestamps
    end
    add_column :services, :service_category_id, :integer
    add_column :services, :person_id, :integer
    add_column :services, :rate, :float
    remove_column :services, :name
    remove_column :services, :image_uid
  end
end
