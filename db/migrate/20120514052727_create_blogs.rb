class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.integer :person_id
      t.integer :company_id
      t.string :url
      t.string :feed_url

      t.timestamps
    end
  end
end
