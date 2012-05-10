class CreateFeaturedItems < ActiveRecord::Migration
  def change
    create_table :featured_items do |t|
      t.boolean :published, default: false, null: false
      t.integer :resource_id
      t.string :resource_type
      t.timestamps
    end
  end
end
