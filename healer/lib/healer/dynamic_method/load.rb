class Healer::DynamicMethod::Load
  SAFE_METHODS = %w[index show new create edit update destroy].freeze

  attr_reader :klass

  def initialize(klass:)
    @klass = klass
  end

  def self.call(...)
    new(...).call
  end

  def call
    ::DynamicMethod
      .where(class_name: klass.name, method_name: SAFE_METHODS)
      .find_each do |dm|  
        load_safe_method(dm.method_name, dm.method_source)
    end
  end

  private

  def load_safe_method(method_name, method_source)
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass, method_name: method_name, method_source: method_source
    )
  end
end