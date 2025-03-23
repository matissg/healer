require "open3"

class Healer::DynamicMethod::Test
  include ::Healer::Concerns::WithLogger

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
    result = run_method_unit_tests
    update_healer_error_event_result(result)
  end

  private

  def run_method_unit_tests
    Rails.logger.info("Running tests for #{class_name}##{method_name}")
    cmd = "RAILS_ENV=test bundle exec rspec spec/requests/#{class_name.underscore}_spec.rb"
    stdout, stderr, status = Open3.capture3(cmd)

    puts stdout
    warn stderr unless stderr.empty?

    status.success?
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
