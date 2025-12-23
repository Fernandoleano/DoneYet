# Slack OAuth Configuration
SLACK_CLIENT_ID = Rails.application.credentials.dig(:slack, :client_id)
SLACK_CLIENT_SECRET = Rails.application.credentials.dig(:slack, :client_secret)
SLACK_SIGNING_SECRET = Rails.application.credentials.dig(:slack, :signing_secret)

# Configure Slack client
Slack.configure do |config|
  config.token = nil # Will be set per-workspace
end
