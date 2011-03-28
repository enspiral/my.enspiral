class UpdateProjectFields < ActiveRecord::Migration
  def self.up
    remove_column :projects, :city
    remove_column :projects, :image_updated_at
    remove_column :projects, :image_file_size
    remove_column :projects, :image_content_type
    remove_column :projects, :image_file_name
    add_column :projects, :customer_id, :integer
    add_column :projects, :person_id, :integer
    add_column :projects, :budget, :decimal, :precision => 10, :scale => 2
    add_column :projects, :due_date, :date
  end

  def self.down
    remove_column :projects, :due_date
    remove_column :projects, :budget
    remove_column :projects, :person_id
    remove_column :projects, :customer_id
    add_column :projects, :city, :string
    add_column :projects, :image_file_name, :string
    add_column :projects, :image_content_type, :string
    add_column :projects, :image_file_size, :integer
    add_column :projects, :image_updated_at, :datetime
  end
end
