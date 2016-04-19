class AddPrivateKeyFileNameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :private_key_file_name, :string

    unless Rails.env == "test" || Rails.env == "cucumber"
      enspiral_services = Company.enspiral_services
      enspiral_services.private_key_file_name = "privatekey"
      enspiral_services.save

      embassy_network = Company.embassy_network
      embassy_network.private_key_file_name = "embassynetwork"
      embassy_network.save
    end
  end
end
