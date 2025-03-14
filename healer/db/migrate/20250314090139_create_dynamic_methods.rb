class CreateDynamicMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :dynamic_methods do |t|
      t.string :class_name
      t.string :method_name
      t.text :method_source

      t.timestamps
    end
  end
end
