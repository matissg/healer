module Healer::Concerns::WithLogger
  extend ActiveSupport::Concern

  private

  def log(action_name, result)
    healer_error_event.activity_logs.create!(action_name: action_name, result: result)
  end
end
