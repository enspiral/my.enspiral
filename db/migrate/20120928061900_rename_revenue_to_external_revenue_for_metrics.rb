class RenameRevenueToExternalRevenueForMetrics < ActiveRecord::Migration
  def change
    rename_column :metrics, :revenue, :external_revenue

    add_column :metrics, :internal_revenue, :decimal, :precision => 8, :scale => 2
  end
end
