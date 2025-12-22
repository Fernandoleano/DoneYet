class MissionPursuitJob < ApplicationJob
  queue_as :default

  def perform
    # Find active missions in "dispatched" meetings
    missions = Mission.includes(meeting: :workspace).where(status: :pending)
                      .where.not(dispatch_status: :failed)

    missions.each do |mission|
      process_mission(mission)
    end
  end

  private

  def process_mission(mission)
    return if recent_reminder?(mission)

    if due_in_24_hours?(mission)
      send_reminder(mission, "⏰ **CLOCK IS TICKING**\nReminder: '#{mission.title}' is due in 24 hours.")
    elsif due_now?(mission)
      send_reminder(mission, "⚡ **ZERO HOUR**\n'#{mission.title}' is due NOW.")
    elsif overdue_24_hours?(mission)
      send_reminder(mission, "⚠️ **MISSION OVERDUE**\n'#{mission.title}' is 24 hours late. Report status.")
    end
  end

  def recent_reminder?(mission)
    mission.last_reminded_at && mission.last_reminded_at > 12.hours.ago
  end

  def due_in_24_hours?(mission)
    time_until = mission.due_at - Time.current
    time_until.between?(23.hours, 25.hours)
  end

  def due_now?(mission)
    time_until = mission.due_at - Time.current
    time_until.between?(-1.hour, 1.hour)
  end

  def overdue_24_hours?(mission)
    time_since = Time.current - mission.due_at
    time_since.between?(23.hours, 25.hours)
  end

  def send_reminder(mission, text)
    workspace = mission.meeting.workspace
    integration = workspace.integrations.slack.first
    return unless integration

    client = SlackClient.new(integration.access_token)

    mission_url = Rails.application.routes.url_helpers.mission_url(mission, host: ENV.fetch("APP_HOST", "http://localhost:3000"))
    full_text = "#{text}\n<#{mission_url}|View Mission>"

    response = client.post_message(channel: mission.agent.slack_user_id, text: full_text)

    if response["ok"]
      mission.update(last_reminded_at: Time.current)
    end
  end
end
