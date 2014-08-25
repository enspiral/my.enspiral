class ChangeColumnAmountInFundsTransferTemplateLine < ActiveRecord::Migration
  def up
  	change_column :funds_transfer_template_lines, :amount, :decimal, :precision => 10, :scale => 2
  end

  def down
  	change_column :funds_transfer_template_lines, :amount, :decimal
  end
end
