class Healer::DynamicMethod::Load
  SAFE_METHODS = %w[index show new create edit update destroy].freeze

  attr_reader :klass, :action_name

  def initialize(klass:, action_name:)
    @klass = klass
    @action_name = action_name
  end

  def self.call(...)
    new(...).call
  end

  def call
    event = ::Healer::ErrorEvent.where(class_name: klass.name, method_name: action_name, success: true).last
    return if event.blank?

    load_safe_method(event.method_name, event.method_source)
  end

  private

  def load_safe_method(method_name, method_source)
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass, method_name: method_name, method_source: method_source
    )
  end
end