class CreateHealerErrorEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :healer_error_events do |t|
      t.string :class_name, null: false, comment: "The class name where the error occurred"
      t.string :method_name, null: false, comment: "The method name where the error occurred"
      t.json :error, null: false, default: {}, comment: "The error details"

      t.timestamps
    end

    add_index(:healer_error_events, %i[class_name method_name], unique: true)
  end
end
