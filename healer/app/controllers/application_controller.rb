require "timeout"

class ApplicationController < ActionController::Base
  TIMEOUT_SEC = 5

  before_action :load_dynamic_methods, only: %i[index show update destroy]
  around_action :apply_timeout_to_methods, only: %i[index show update destroy]

  rescue_from StandardError, with: :resolve_error

  private

  def load_dynamic_methods
    ::Healer::DynamicMethod::Load.call(klass: self.class)
  end

  def call_healer(error)
    ::Healer::DynamicMethod::Create.call(klass: self.class, action_name: action_name, error: error)
  end

  def apply_timeout_to_methods
    Timeout.timeout(TIMEOUT_SEC) { yield }
  rescue Timeout::Error
    call_healer(error: "Request timed out for #{self.class}##{action_name}")
  end

  def resolve_error(exception)
    call_healer(
      error: {
        error: exception.message,
        cause: exception.cause&.message,
        backtrace: exception.backtrace.first(5)
      }
    )
  end
end
