class SlackIntegrationsController < ApplicationController
  before_action :require_authentication
  before_action :require_pro_access!

  def show
    @workspace = current_workspace
  end

  def connect
    # Redirect to Slack OAuth
    redirect_to slack_oauth_url, allow_other_host: true
  end

  def callback
    # Exchange code for access token
    response = HTTParty.post("https://slack.com/api/oauth.v2.access",
      body: {
        client_id: SLACK_CLIENT_ID,
        client_secret: SLACK_CLIENT_SECRET,
        code: params[:code],
        redirect_uri: callback_slack_integration_url
      }
    )

    if response["ok"]
      current_workspace.update(
        slack_team_id: response["team"]["id"],
        slack_team_name: response["team"]["name"],
        slack_access_token: response["access_token"],
        slack_bot_token: response["access_token"],
        slack_connected_at: Time.current
      )

      redirect_to slack_integration_path, notice: "Successfully connected to Slack!"
    else
      redirect_to slack_integration_path, alert: "Failed to connect to Slack: #{response['error']}"
    end
  end

  def disconnect
    current_workspace.disconnect_slack!
    redirect_to slack_integration_path, notice: "Disconnected from Slack"
  end

  private

  def slack_oauth_url
    params = {
      client_id: SLACK_CLIENT_ID,
      scope: "channels:read,chat:write,users:read",
      redirect_uri: callback_slack_integration_url
    }
    "https://slack.com/oauth/v2/authorize?#{params.to_query}"
  end
end
