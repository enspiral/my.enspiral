class AddTimeZoneToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :time_zone, :string, null: false, default: "Wellington"

    change_column_default :companies, :time_zone, "UTC"
  end
end
