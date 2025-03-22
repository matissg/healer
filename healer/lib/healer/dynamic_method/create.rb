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
    return if ::DynamicMethod.exists?(class_name: klass.name, method_name: action_name)

    # tested = run_method_unit_tests if define_safe_method
    create_dynamic_method #if tested
  end

  private

  def openai_prompt
    ::Healer::Openai::Prompt.call(klass: klass, action_name: action_name, error: error)
  end

  def openai_response
    @openai_response ||= ::Healer::Openai::Response.call(prompt: openai_prompt)
  end

  def define_safe_method
    ::Healer::DynamicMethod::SafeMethod.call(
      klass: klass,
      method_name: action_name,
      method_source: openai_response["method_source"]
    )
  end

  def run_method_unit_tests
    cmd = "RAILS_ENV=test bundle exec rspec spec/requests/#{klass.name.underscore}_spec.rb"
    stdout, stderr, status = Open3.capture3(cmd)
  
    puts stdout
    warn stderr unless stderr.empty?
  
    status.success?
  end

  def create_dynamic_method
    ::DynamicMethod.create!(
      class_name: openai_response["class_name"],
      method_name: openai_response["method_name"],
      method_source: openai_response["method_source"]
    )
  end
end
