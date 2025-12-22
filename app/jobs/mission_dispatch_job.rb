class MissionDispatchJob < ApplicationJob
  queue_as :default

  def perform(mission)
    return if mission.canceled? || mission.dispatch_sent?

    workspace = mission.meeting.workspace
    integration = workspace.integrations.slack.first

    unless integration
      mission.update!(dispatch_status: :failed, dispatch_metadata: { error: "No Slack integration" })
      return
    end

    agent = mission.agent
    slack_client = SlackClient.new(integration.access_token)

    # Resolve Slack ID if missing
    unless agent.slack_user_id
      response = slack_client.lookup_user_by_email(agent.email_address)
      if response["ok"]
        agent.update!(slack_user_id: response["user"]["id"])
      else
        mission.update!(dispatch_status: :failed, dispatch_metadata: { error: "User lookup failed", response: response })
        return
      end
    end

    # Send Message
    mission_url = Rails.application.routes.url_helpers.mission_url(mission, host: ENV.fetch("APP_HOST", "http://localhost:3000"))

    message_text = "🕵️ *MISSION ASSIGNMENT: #{mission.title}*\n" \
                   "**Briefing:** #{mission.meeting.title}\n" \
                   "**Directive:** Complete by #{mission.due_at.strftime('%Y-%m-%d %H:%M')}\n" \
                   "<%#{mission_url}|👉 Acknowledge & View Details>"

    response = slack_client.post_message(channel: agent.slack_user_id, text: message_text)

    if response["ok"]
      mission.update!(
        dispatch_status: :sent,
        dispatch_metadata: { ts: response["ts"], channel: response["channel"] }
      )
    else
      mission.update!(
        dispatch_status: :failed,
        dispatch_metadata: { error: "Send failed", response: response }
      )
    end
  rescue StandardError => e
    mission.update!(dispatch_status: :failed, dispatch_metadata: { error: e.message })
    raise e
  end
end
