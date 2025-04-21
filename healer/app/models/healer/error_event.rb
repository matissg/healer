class Healer::ErrorEvent < ApplicationRecord
  self.table_name = "healer_error_events"

  has_many :activity_logs, class_name: "Healer::ActivityLog", foreign_key: :error_event_id, dependent: :destroy
end

# == Schema Information
#
# Table name: healer_error_events
#
#  id                                                    :bigint           not null, primary key
#  class_name(The class name where the error occurred)   :string           not null
#  error(The error details)                              :json             not null
#  method_name(The method name where the error occurred) :string           not null
#  method_source(The source code of the method)          :text
#  prompt(The prompt for AI agent)                       :json             not null
#  response(The response from AI agent)                  :json             not null
#  success(The success status of the mitigation)         :boolean          default(FALSE), not null
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#
# Indexes
#
#  index_healer_error_events_on_class_name_and_method_name  (class_name,method_name) UNIQUE
#
