class CreateHealerErrorMitigations < ActiveRecord::Migration[8.1]
  def change
    create_table :healer_error_mitigations do |t|
      t.references :healer_error_event, null: false, foreign_key: true
      t.json :prompt, null: false, default: {}, comment: "The prompt for AI agent"
      t.json :response, null: false, default: {}, comment: "The response from AI agent"
      t.text :method_source, comment: "The source code of the method"
      t.boolean :success, null: false, default: false, comment: "The success status of the mitigation"

      t.timestamps
    end
  end
end
