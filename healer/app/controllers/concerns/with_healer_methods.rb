module WithHealerMethods
  extend ActiveSupport::Concern

  TIMEOUT_SEC = 30

  included do
    before_action :load_dynamic_methods, only: ::Healer::DynamicMethod::Load::SAFE_METHODS, unless: :test_env?
    around_action :apply_timeout_to_methods, only: ::Healer::DynamicMethod::Load::SAFE_METHODS, unless: :test_env?
    rescue_from StandardError, with: :resolve_error
  end

  private

  def test_env?
    Rails.env.test?
  end

  def load_dynamic_methods
    ::Healer::DynamicMethod::Load.call(klass: self.class)
  end

  def create_error_event(error)
    ::Healer::ErrorEvent.create_or_find_by!(class_name: self.class.name, method_name: action_name) do |event|
      event.error = error.to_json
    end
  rescue ActiveRecord::RecordInvalid => exception
    Rails.logger.error("Error creating error event: #{exception.message}")
    nil
  end

  def redirect_to_error_event(error)
    error_event = create_error_event(error)

    redirect_to edit_healer_error_event_path(id: error_event.id)
  end

  def apply_timeout_to_methods
    Timeout.timeout(TIMEOUT_SEC) { yield }
  rescue Timeout::Error
    redirect_to_error_event(error: "Request timed out for #{self.class}##{action_name}")
  end

  def resolve_error(exception)
    return if test_env?

    redirect_to_error_event(
      error: {
        error: exception.message,
        cause: exception.cause&.message,
        backtrace: exception.backtrace.first(5)
      }
    )
  end
end