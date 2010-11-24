class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.references :person
      t.string :summary
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
