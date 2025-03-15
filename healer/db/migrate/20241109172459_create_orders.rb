class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.bigint :user_id, null: false, index: true
      t.string :product_name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false
      t.decimal :total

      t.timestamps
    end
  end
end
