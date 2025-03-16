class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.bigint :user_id, null: false, index: true
      t.bigint :product_catalog_guid
      t.string :product_name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity, null: false, default: 1
      t.decimal :total, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
