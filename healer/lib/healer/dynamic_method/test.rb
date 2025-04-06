require "open3"

class Healer::DynamicMethod::Test
  include ::Healer::Concerns::WithLogger

  # This is a temporary file to store the dynamic method definition
  # and will be deleted after the test is run.
  TEMP_FILE_PATH = Rails.root.join("spec/support/temp_dynamic_eval.rb").freeze
  private_constant :TEMP_FILE_PATH

  attr_reader :healer_error_event, :class_name, :method_name

  def initialize(healer_error_event:)
    @healer_error_event = healer_error_event
    @class_name = @healer_error_event.class_name
    @method_name = @healer_error_event.method_name
  end

  def self.call(...)
    new(...).call
  end

  def call
    define_safe_method

    result = run_method_unit_tests
    update_healer_error_event_result(result)
  end

  private

  def define_safe_method
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: class_name,
      method_name: method_name,
      method_source: healer_error_event.method_source,
      temp_file_path: TEMP_FILE_PATH
    )
  end

  def cleanup_dynamic_method
    File.delete(TEMP_FILE_PATH) if TEMP_FILE_PATH && File.exist?(TEMP_FILE_PATH)
  end

  def run_method_unit_tests
    Rails.logger.info("Running tests for #{class_name}##{method_name}")
    cmd = "RAILS_ENV=test bundle exec rspec spec/requests/#{class_name.underscore}_spec.rb"
    stdout, stderr, status = Open3.capture3(cmd)

    puts stdout
    warn stderr unless stderr.empty?

    status.success?
  ensure
    cleanup_dynamic_method
  end

  def update_healer_error_event_result(result)
    if result == false
      log(
        "Dynamic method test fail",
        "Healer::ErrorEvent ID=#{healer_error_event.id} not mitigated".to_json
      )
    else
      log(
        "Dynamic method test success",
        "Healer::ErrorEvent ID=#{healer_error_event.id} mitigated".to_json
      )

      healer_error_event.update!(success: true)
    end
  end
end
