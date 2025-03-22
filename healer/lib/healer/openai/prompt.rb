class Healer::Openai::Prompt
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
    {
      prompt: PROMPT,
      error: error,
      class_name: klass.name,
      method_name: action_name,
      method_source: method_source,
      class_source: class_source,
      view_source: view_source
    }
  end

  private

  def method_source
    method_obj = klass.instance_method(action_name.to_sym) rescue nil
    return SOURCE_CODE_UNAVAILABLE unless method_obj

    file, line = method_obj.source_location
    return SOURCE_CODE_UNAVAILABLE unless file && line

    lines = File.readlines(file)
    method_lines = lines[line - 1..-1].take_while { |line| !line.strip.empty? }
    method_lines.join
  rescue
    SOURCE_CODE_UNAVAILABLE
  end

  def class_source
    file, _line = klass.instance_method(klass.instance_methods(false).first).source_location rescue nil
    return SOURCE_CODE_UNAVAILABLE unless file

    File.read(file) rescue SOURCE_CODE_UNAVAILABLE
  end

  def view_source
    controller_name = klass.name.sub("Controller", "").underscore

    ALLOWED_VIEW_FILE_EXTENSIONS.each do |ext|
      view_file = Rails.root.join("app", "views", controller_name, "#{action_name}.#{ext}")

      return File.read(view_file) if File.exist?(view_file)
    end

    SOURCE_CODE_UNAVAILABLE
  rescue
    SOURCE_CODE_UNAVAILABLE
  end
end