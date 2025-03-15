class Healer::Openai::Response
  MODEL = "gpt-4o"
  RESPONSE_FORMAT = { type: "json_object" }
  ROLE = "user"

  private_constant :MODEL, :RESPONSE_FORMAT, :ROLE

  attr_reader :prompt

  def initialize(prompt:)
    @prompt = prompt
  end

  def self.call(...)
    new(...).call
  end

  def call
    JSON.parse(chat.dig("choices", 0, "message", "content"))
  end

  private

  def chat
    ::OpenAI::Client.new.chat(
      parameters: {
        model: MODEL,
        response_format: RESPONSE_FORMAT,
        messages: [{ role: ROLE, content: prompt.to_s}]
      }
    )
  end
end