OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai.access_token
  # config.admin_token = ENV.fetch("OPENAI_ADMIN_TOKEN") # Optional, used for admin endpoints, created here: https://platform.openai.com/settings/organization/admin-keys
  config.organization_id = Rails.application.credentials.openai.organization_id
  config.log_errors = true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
end