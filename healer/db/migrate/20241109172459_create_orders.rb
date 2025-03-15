class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.bigint :user_id, null: false
      t.decimal :total

      t.timestamps
    end
  end
end
