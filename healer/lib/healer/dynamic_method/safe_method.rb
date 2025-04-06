class Healer::DynamicMethod::SafeMethod
  attr_reader :klass, :method_name, :method_source, :temp_file_path

  def initialize(klass:, method_name:, method_source:, temp_file_path: nil)
    @klass = klass
    @method_name = method_name
    @method_source = method_source
    @temp_file_path = temp_file_path
  end

  def self.call(...)
    new(...).call
  end

  def call
    return if sanitized_method_source.blank?
    return  define_dynamic_method if temp_file_path.blank?

    write_dynamic_method_to_temp_file
  end

  private

  def sanitized_method_source
    @sanitized_method_source ||=
      method_source.match?(/(`|system|exec|File|IO|open|eval|Thread)/) ? "" : method_source
  end

  def define_dynamic_method
    klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        #{sanitized_method_source}
      end
    RUBY
  rescue => error
    Rails.logger.error("Error defining method #{method_name}: #{error.message}")
    false
  end

  # This method writes the dynamic method to a temporary file for unit testing.
  def write_dynamic_method_to_temp_file
    File.write(temp_file_path, <<~RUBY)
      #{klass}.class_eval do
        def #{method_name}
          @dynamic_method_written = true
          #{sanitized_method_source}
        end
      end
    RUBY
  end
end
