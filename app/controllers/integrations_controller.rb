require "net/http"

class IntegrationsController < ApplicationController
  def new
  end

  def create
    if params[:provider] == "slack"
      client_id = ENV["SLACK_CLIENT_ID"]
      scope = "chat:write,im:write,users:read"
      redirect_uri = slack_callback_url

      url = "https://slack.com/oauth/v2/authorize?client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
      redirect_to url, allow_other_host: true
    else
      redirect_to root_path, alert: "Unknown provider"
    end
  end

  def slack_callback
    code = params[:code]

    if code
      uri = URI("https://slack.com/api/oauth.v2.access")
      res = Net::HTTP.post_form(uri, {
        "client_id" => ENV["SLACK_CLIENT_ID"],
        "client_secret" => ENV["SLACK_CLIENT_SECRET"],
        "code" => code,
        "redirect_uri" => slack_callback_url
      })

      data = JSON.parse(res.body)

      if data["ok"]
        # Create integration
        Current.user.workspace.integrations.create!(
          provider: :slack,
          access_token: data["access_token"],
          bot_user_id: data["bot_user_id"],
          configuration: { team_id: data["team"]["id"], team_name: data["team"]["name"] }
        )
        redirect_to root_path, notice: "Slack successfully connected!"
      else
        redirect_to root_path, alert: "Slack connection failed: #{data['error']}"
      end
    else
      redirect_to root_path, alert: "Slack connection cancelled"
    end
  end
end
