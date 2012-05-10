class CreateFeaturedItems < ActiveRecord::Migration
  def change
    create_table :featured_items do |t|
      t.references :resourceable, ploymorphic: true
      t.timestamps
    end
  end
end
