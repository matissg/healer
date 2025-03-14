require "timeout"

class ApplicationController < ActionController::Base
  SAFE_METHODS = %w[index show update destroy].freeze
  SOURCE_CODE_UNAVAILABLE = "Source code not available"
  TIMEOUT_SEC = 5

  before_action :load_dynamic_methods
  around_action :apply_timeout_to_methods

  private

  def sanitize_method_code(code)
    return "" if code.match?(/(`|system|exec|File|IO|open|eval|Thread)/)
  
    code
  end
  
  def define_safe_method(method_name, method_source)
    self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        #{method_source}
      end
    RUBY
  rescue SyntaxError, StandardError => e
    Rails.logger.error("Error defining method #{method_name}: #{e.message}")
  end

  def load_dynamic_methods
    @loaded_methods ||= {}
  
    DynamicMethod.where(class_name: self.class.name).find_each do |dm|
      next if @loaded_methods[dm.method_name] == dm.updated_at
      next unless SAFE_METHODS.include?(dm.method_name)
  
      method_source = sanitize_method_code(dm.method_source)
  
      if method_source.present?
        define_safe_method(dm.method_name, method_source)
        @loaded_methods[dm.method_name] = dm.updated_at
      end
    end
  end

  def request_timeout_prompt
    <<-PROMPT
      Read the following prompt and following details in this JSON file.
      Without explaining return improved method Ruby code as JSON response:
      1) class_name as string
      2) method_name as string
      3) method_source as string
      Your limits:
      1) do not limit user functionality, input, output, experience
      2) do not limit returned data
      3) do not comment or explain code
      4) do not include "def" and "end" in method_source
    PROMPT
  end

  def timed_out_error
    "Request timed out for #{self.class}##{action_name}"
  end

  def prompt_for_ai
    {
      prompt: request_timeout_prompt,
      error: timed_out_error,
      class_name: self.class.name,
      method_name: action_name,
      method_source: get_method_source(self.class, action_name),
      class_source: get_class_source(self.class),
      view_source: get_view_source(self.class, action_name)
    }
  end

  def openai_response
    @openai_response ||= begin
      content =
        OpenAI::Client.new.chat(
          parameters: {model: "gpt-4o",
          response_format: { type: "json_object" },
          messages: [{ role: "user", content: prompt_for_ai.to_s}] }
        )

      json = content.dig("choices", 0, "message", "content")
      JSON.parse(json)
    end
  end

  def create_dynamic_method
    DynamicMethod.create!(
      class_name: openai_response["class_name"],
      method_name: openai_response["method_name"],
      method_source: openai_response["method_source"]
    )
  end

  def apply_timeout_to_methods
    begin
      Timeout.timeout(TIMEOUT_SEC) { yield }
    rescue Timeout::Error
      create_dynamic_method
      redirect_to request.path, notice: "We noticed performance issue and tried to improve it. Please try again."
    end
  end

  def get_method_source(klass, method_name)
    method_obj = klass.instance_method(method_name.to_sym) rescue nil
    return SOURCE_CODE_UNAVAILABLE unless method_obj

    file, line = method_obj.source_location
    return SOURCE_CODE_UNAVAILABLE unless file && line

    lines = File.readlines(file)
    method_lines = lines[line - 1..-1].take_while { |l| !l.strip.empty? }
    method_lines.join
  rescue
    SOURCE_CODE_UNAVAILABLE
  end

  def get_class_source(klass)
    file, _line = klass.instance_method(klass.instance_methods(false).first).source_location rescue nil
    return SOURCE_CODE_UNAVAILABLE unless file

    File.read(file) rescue SOURCE_CODE_UNAVAILABLE
  end

  def get_view_source(klass, action_name)
    controller_name = klass.name.sub("Controller", "").underscore
    possible_extensions = %w[html.erb json.jbuilder]

    possible_extensions.each do |ext|
      view_file = Rails.root.join("app", "views", controller_name, "#{action_name}.#{ext}")

      return File.read(view_file) if File.exist?(view_file)
    end

    SOURCE_CODE_UNAVAILABLE
  rescue
    SOURCE_CODE_UNAVAILABLE
  end
end
