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

  def resolvable?
    return true unless healer_error_event.success?

    healer_error_event.errors.add(:base, "Error event already resolved")
    false
  end

  def openai_response
    ::Healer::Openai::Response.call(healer_error_event: healer_error_event)
  end

  def run_uinit_test
    # Let's run respective unit test to see if the new method works
    ::Healer::DynamicMethod::Test.call(healer_error_event: healer_error_event)
  end
end
