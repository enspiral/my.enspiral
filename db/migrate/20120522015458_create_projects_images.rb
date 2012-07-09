class CreateProjectsImages < ActiveRecord::Migration
  def change
    create_table :projects_images do |t|
      t.integer :project_id
      t.string :image_uid

      t.timestamps
    end
  end
end
