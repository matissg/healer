require "timeout"

class ApplicationController < ActionController::Base
  TIMEOUT_SEC = 30

  before_action :load_dynamic_methods, only: ::Healer::DynamicMethod::Load::SAFE_METHODS, unless: :test_env?
  around_action :apply_timeout_to_methods, only: ::Healer::DynamicMethod::Load::SAFE_METHODS, unless: :test_env?
  rescue_from StandardError, with: :resolve_error

  private

  def test_env?
    Rails.env.test?
  end

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
    return if test_env?

    call_healer(
      error: {
        error: exception.message,
        cause: exception.cause&.message,
        backtrace: exception.backtrace.first(5)
      }
    )
  end
end
