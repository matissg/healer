class CreateHealerLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :healer_logs do |t|
      t.string :action_name, comment: "Action taken"
      t.string :result, comment: "The result of the action"

      t.datetime :created_at, null: false, comment: "The creation time of the log"
    end
  end
end
