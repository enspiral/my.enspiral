class AddEstimatedValueToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :amount_quoted, :decimal, :precision => 10, :scale => 2, :null => true
  end
end
