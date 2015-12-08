class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.decimal :amount, scale: 2, precision: 5
      t.string :reference_id
      t.timestamps
    end
  end
end
