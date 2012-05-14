class AddMarketingFieldsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :country_id, :integer
    add_column :companies, :city_id, :integer
    add_column :companies, :contact_name, :string
    add_column :companies, :contact_phone, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :contact_skype, :string
    add_column :companies, :webiste, :string
    add_column :companies, :blog_url, :string
    add_column :companies, :address, :text
  end
end
