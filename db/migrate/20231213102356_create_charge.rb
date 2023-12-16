class CreateCharge < ActiveRecord::Migration[7.1]
  def change
    create_table :charges do |t|
      t.string :charge_id
      t.integer :amount
      t.integer :amount_refunded
      t.string :currency
    end
  end
end
