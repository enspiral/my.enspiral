class RemovePaperclipFromBadge < ActiveRecord::Migration
  def self.up
    remove_column :badges, :image_updated_at
    remove_column :badges, :image_file_size
    remove_column :badges, :image_content_type
    remove_column :badges, :image_file_name
  end

  def self.down
    add_column :badges, :image_file_name, :string
    add_column :badges, :image_content_type, :string
    add_column :badges, :image_file_size, :integer
    add_column :badges, :image_updated_at, :datetime
  end
end
