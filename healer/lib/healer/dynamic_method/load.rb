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
    load_dynamic_methods
  end

  private

  def sanitize_method_code(code)
    return "" if code.match?(/(`|system|exec|File|IO|open|eval|Thread)/)
  
    code
  end
  
  def define_safe_method(method_name, method_source)
    klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        #{method_source}
      end
    RUBY
  rescue => error
    Rails.logger.error("Error defining method #{method_name}: #{error.message}")
  end

  def load_dynamic_methods
    @loaded_methods ||= {}
  
    DynamicMethod.where(class_name: klass.name).find_each do |dm|
      next if @loaded_methods[dm.method_name] == dm.updated_at
      next unless SAFE_METHODS.include?(dm.method_name)
  
      method_source = sanitize_method_code(dm.method_source)
  
      if method_source.present?
        define_safe_method(dm.method_name, method_source)
        @loaded_methods[dm.method_name] = dm.updated_at
      end
    end
  end
end