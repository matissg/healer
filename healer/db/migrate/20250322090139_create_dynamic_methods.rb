class CreateDynamicMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :dynamic_methods do |t|
      t.string :class_name
      t.string :method_name
      t.text :method_source

      t.timestamps
    end

    add_index(:dynamic_methods, %i[class_name method_name], unique: true)
  end
end
