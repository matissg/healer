class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock

      t.timestamps
    end
  end
end
