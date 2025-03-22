module Healer::Concerns::WithLogger
  extend ActiveSupport::Concern

  private

  def log(error_event_id, action_name, result)
    ::Healer::ActivityLog.create!(error_event_id: error_event_id, action_name: action_name, result: result)
  end
end
