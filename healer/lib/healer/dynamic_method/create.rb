class Healer::DynamicMethod::Create
  attr_reader :healer_error_event

  def initialize(healer_error_event:)
    @healer_error_event = healer_error_event
  end

  def self.call(...)
    new(...).call
  end

  def call
    return if healer_error_event.blank?

    run_uinit_test if resolvable? && openai_response
  rescue StandardError => exception
    Rails.logger.error("Error creating dynamic method: #{exception.message}")
    false
  end

  private

  def add_error(message)
    healer_error_event.errors.add(:base, message)
    false
  end

  def resolvable?
    return add_error("Error event already resolved") if healer_error_event.success?
    return add_error("Error event already has method source") if healer_error_event.method_source.present?

    true
  end

  def openai_response
    ::Healer::Openai::Response.call(healer_error_event: healer_error_event)
  end

  def run_uinit_test
    # Let's run respective unit test to see if the new method works
    ::Healer::DynamicMethod::Test.call(healer_error_event: healer_error_event)
  end
end
