require "faraday"
require "json"
require "ostruct"

class Catalog
  BASE_URL = "http://catalog:3001"

  def self.fetch(path)
    response = Faraday.get("#{BASE_URL}/#{path}")

    if response.success?
      # Parse and convert to to OpenStruct objects for compatibility with Rails helpers
      JSON.parse(response.body).map { |product| OpenStruct.new(product) }
    else
      Rails.logger.error("Catalog API Error: #{response.status} - #{response.body}")
      nil
    end
  rescue Faraday::ConnectionFailed => exception
    Rails.logger.error("Catalog API Connection Failed: #{exception.message}")
    nil
  end
end
