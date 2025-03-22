class Healer::DynamicMethod::Create
  include ::Healer::Concerns::WithLogger

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
    return if ::DynamicMethod.exists?(class_name: klass.name, method_name: action_name)

    tested = run_method_unit_tests if define_safe_method
    create_dynamic_method if tested
  end

  private

  def openai_prompt
    ::Healer::Openai::Prompt.call(klass: klass, action_name: action_name, error: error)
  end

  def openai_response
    @openai_response ||= begin
      prompt = openai_prompt
      log("AI prompt", prompt.to_json)
      response = ::Healer::Openai::Response.call(prompt: prompt)
      log("AI response", response.to_json)
      response
    end
  end

  def define_safe_method
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass,
      method_name: action_name,
      method_source: openai_response["method_source"]
    )
  end

  def run_method_unit_tests
    Rails.logger.info("Running tests for #{klass.name}##{action_name}")
    cmd = "RAILS_ENV=test bundle exec rspec spec/requests/#{klass.name.underscore}_spec.rb"
    stdout, stderr, status = Open3.capture3(cmd)
  
    puts stdout
    warn stderr unless stderr.empty?
  
    result = status.success?
    log("Unit test", "Test result for #{klass.name}##{action_name}: #{result}".to_json)
    result
  end

  def create_dynamic_method
    dynamic_method = 
      ::DynamicMethod.create!(
        class_name: openai_response["class_name"],
        method_name: openai_response["method_name"],
        method_source: openai_response["method_source"]
      )

    log("Dynamic method", "DynamicMethod ID=#{dynamic_method.id} created".to_json)
  end
end
