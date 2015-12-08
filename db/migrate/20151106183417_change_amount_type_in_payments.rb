class ChangeAmountTypeInPayments < ActiveRecord::Migration
  def change
    change_column :payments, :amount, :integer
  end
end
