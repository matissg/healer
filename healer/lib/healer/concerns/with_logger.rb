module Healer::Concerns::WithLogger
  extend ActiveSupport::Concern

  private

  def log(action_name, result)
    ::Healer::ActivityLog.create!(action_name: action_name, result: result)
  end
end
