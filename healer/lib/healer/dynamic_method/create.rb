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

    result = run_method_unit_tests
    update_healer_error_event_result(result)
  end

  private

  def healer_error_event
    @healer_error_event ||=
      ::Healer::ErrorEvent.create!(class_name: klass.name, method_name: action_name, error: error.to_json)
  end

  def log(action_name, result)
    healer_error_event.activity_logs.create!(action_name: action_name, result: result)
  end

  def openai_prompt
    prompt = ::Healer::Openai::Prompt.call(klass: klass, action_name: action_name, error: error)
    log("AI prompt", prompt.to_json)
    healer_error_event.update!(prompt: prompt.to_json)
    prompt
  end

  def openai_response
    @openai_response ||= begin
      response = ::Healer::Openai::Response.call(prompt: openai_prompt)
      log("AI response", response.to_json)
      healer_error_event.update!(response: response.to_json, method_source: response["method_source"])
      response
    end
  end

  def define_safe_method
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass,
      method_name: action_name,
      method_source: openai_response["method_source"]
    )

    true
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

  def run_method_unit_tests
    Rails.logger.info("Running tests for #{klass.name}##{action_name}")
    cmd = "RAILS_ENV=test bundle exec rspec spec/requests/#{klass.name.underscore}_spec.rb"
    stdout, stderr, status = Open3.capture3(cmd)

    puts stdout
    warn stderr unless stderr.empty?

    status.success?
  end
end
