class CreateHealerActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :healer_activity_logs do |t|
      t.references :error_event, null: false, foreign_key: { to_table: :healer_error_events }, comment: "The error event"
      t.string :action_name, comment: "Action taken"
      t.json :result, comment: "The result of the action"

      t.datetime :created_at, null: false, index: true, comment: "The creation time of the log"
    end
  end
end
