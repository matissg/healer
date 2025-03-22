class Healer::ActivityLog < ApplicationRecord
  self.table_name = "healer_activity_logs"

  belongs_to :error_event, class_name: "Healer::ErrorEvent", foreign_key: :error_event_id
end

# == Schema Information
#
# Table name: healer_activity_logs
#
#  id                                       :bigint           not null, primary key
#  action_name(Action taken)                :string
#  result(The result of the action)         :json
#  created_at(The creation time of the log) :datetime         not null
#  error_event_id(The error event)          :bigint           not null
#
# Indexes
#
#  index_healer_activity_logs_on_created_at      (created_at)
#  index_healer_activity_logs_on_error_event_id  (error_event_id)
#
# Foreign Keys
#
#  fk_rails_...  (error_event_id => healer_error_events.id)
#
