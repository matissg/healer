class Healer::DynamicMethod::Create
  attr_reader :klass, :action_name, :error

  def initialize(klass:, action_name:, error:)
    @klass = klass
    @action_name = action_name
    @error = error
  end

  def self.call(...)
    new(...).call
  end

  def call
    return if ::Healer::ErrorEvent.exists?(class_name: klass.name, method_name: action_name)
    return unless define_safe_method

    # Let's run respective unit test to see if the new method works
    ::Healer::DynamicMethod::Test.call(healer_error_event: healer_error_event)
  end

  private

  def healer_error_event
    @healer_error_event ||=
      ::Healer::ErrorEvent.create!(class_name: klass.name, method_name: action_name, error: error.to_json)
  end

  def openai_response
    ::Healer::Openai::Response.call(healer_error_event: healer_error_event)
  end

  def define_safe_method
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass,
      method_name: action_name,
      method_source: openai_response["method_source"]
    )

    true
  end
end
