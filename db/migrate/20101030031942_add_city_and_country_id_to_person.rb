class AddCityAndCountryIdToPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :city
    
    add_column :people, :country_id, :integer
    add_column :people, :city_id, :integer
  end

  def self.down
    remove_columns :people, :city_id, :country_id
    
    add_column :people, :city, :string
  end
end
