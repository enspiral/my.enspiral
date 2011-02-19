class AddPeopleContacts < ActiveRecord::Migration
  def self.up
    add_column :people, :twitter, :string
    add_column :people, :skype, :string
  end

  def self.down
    remove_column :people, :skype
    remove_column :people, :twitter
  end
end
