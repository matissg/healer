require "open3"

class Healer::DynamicMethod::SafeMethod
  attr_reader :klass, :method_name, :method_source

  def initialize(klass:, method_name:, method_source:)
    @klass = klass
    @method_name = method_name
    @method_source = method_source
  end

  def self.call(...)
    new(...).call
  end

  def call
    define_safe_method
    true
  end

  private

  def sanitized_method_source
    return "" if method_source.match?(/(`|system|exec|File|IO|open|eval|Thread)/)
  
    method_source
  end

  def define_safe_method
    code = sanitized_method_source
    return if code.blank?

    klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        #{code}
      end
    RUBY
  rescue => error
    Rails.logger.error("Error defining method #{method_name}: #{error.message}")
    false
  end
end
