class CreateHealerErrorEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :healer_error_events do |t|
      t.string :class_name, null: false, comment: "The class name where the error occurred"
      t.string :method_name, null: false, comment: "The method name where the error occurred"
      t.json :error, null: false, default: {}, comment: "The error details"
      t.json :prompt, null: false, default: {}, comment: "The prompt for AI agent"
      t.json :response, null: false, default: {}, comment: "The response from AI agent"
      t.text :method_source, comment: "The source code of the method"
      t.boolean :success, null: false, default: false, comment: "The success status of the mitigation"

      t.timestamps
    end

    add_index(:healer_error_events, %i[class_name method_name], unique: true)
  end
end
