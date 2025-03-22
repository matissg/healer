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
    create_dynamic_method unless ::DynamicMethod.exists?(class_name: klass.name, method_name: action_name)
  end

  private

  def openai_prompt
    ::Healer::Openai::Prompt.call(klass: klass, action_name: action_name, error: error)
  end

  def openai_response
    @openai_response ||= ::Healer::Openai::Response.call(prompt: openai_prompt)
  end

  def create_dynamic_method
    ::DynamicMethod.create!(
      class_name: openai_response["class_name"],
      method_name: openai_response["method_name"],
      method_source: openai_response["method_source"]
    )
  end
end
