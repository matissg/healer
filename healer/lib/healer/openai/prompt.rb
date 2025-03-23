class Healer::Openai::Prompt
  include ::Healer::Concerns::WithLogger

  PROMPT = <<-PROMPT
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
  .freeze

  SOURCE_CODE_UNAVAILABLE = "Source code not available"
  ALLOWED_VIEW_FILE_EXTENSIONS = %w[html.erb json.jbuilder].freeze

  private_constant :PROMPT, :SOURCE_CODE_UNAVAILABLE

  attr_reader :healer_error_event, :klass, :method_name

  def initialize(healer_error_event:)
    @healer_error_event = healer_error_event
    @klass = @healer_error_event.class_name.safe_constantize
    @method_name = @healer_error_event.method_name
  end

  def self.call(...)
    new(...).call
  end

  def call
    prompt_json = prompt.to_json
    log("AI prompt", prompt_json)
    healer_error_event.update!(prompt: prompt_json)

    prompt
  end

  private

  def prompt
    @prompt ||= {
      prompt: PROMPT,
      error: healer_error_event.error,
      class_name: healer_error_event.class_name,
      method_name: method_name,
      class_source: class_source,
      method_source: method_source,
      view_source: view_source
    }
  end

  def log_code_unavailable(type)
    log("AI prompt failure: #{type}", SOURCE_CODE_UNAVAILABLE)
    false
  end

  def class_source
    file, _line = klass.instance_method(klass.instance_methods(false).first).source_location rescue nil
    return log_code_unavailable("class_source") unless file

    File.read(file) rescue log_code_unavailable("class_source")
  end

  def method_source
    method_obj = klass.instance_method(method_name.to_sym) rescue nil
    return log_code_unavailable("method_source") unless method_obj

    file, line = method_obj.source_location
    return log_code_unavailable("method_source") unless file.present? && line.present?

    lines = File.readlines(file)
    method_lines = lines[line - 1..-1].take_while { |line| !line.strip.empty? }
    method_lines.join
  rescue
    log_code_unavailable("method_source")
  end

  def view_source
    controller_name = klass.name.sub("Controller", "").underscore

    ALLOWED_VIEW_FILE_EXTENSIONS.each do |ext|
      view_file = Rails.root.join("app", "views", controller_name, "#{method_name}.#{ext}")

      return File.read(view_file) if File.exist?(view_file)
    end

    log_code_unavailable("view_source")
  rescue
    log_code_unavailable("view_source")
  end
end