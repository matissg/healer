class Healer::Openai::Response
  include ::Healer::Concerns::WithLogger

  MODEL = "gpt-4o"
  RESPONSE_FORMAT = { type: "json_object" }.freeze
  ROLE = "user"

  private_constant :MODEL, :RESPONSE_FORMAT, :ROLE

  attr_reader :healer_error_event

  def initialize(healer_error_event:)
    @healer_error_event = healer_error_event
  end

  def self.call(...)
    new(...).call
  end

  def call
    log("AI response", result)
    healer_error_event.update!(response: chat, method_source: result["method_source"])
  end

  private

  def prompt
    ::Healer::Openai::Prompt.call(healer_error_event: healer_error_event)
  end

  def chat
    @chat ||= begin
      ::OpenAI::Client.new.chat(
        parameters: {
          model: MODEL,
          response_format: RESPONSE_FORMAT,
          messages: [{ role: ROLE, content: prompt}]
        }
      )
    end
  end

  def result
    @result ||= JSON.parse(chat.dig("choices", 0, "message", "content"))
  end
end