# frozen_string_literal: true

class GoogleCalendarService
  def initialize(user)
    @user = user
  end

  def create_meet_event(title:, start_time: Time.current)
    require "google/apis/calendar_v3"
    require "googleauth"

    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = authorize_user

    event = Google::Apis::CalendarV3::Event.new(
      summary: title,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: start_time.iso8601,
        time_zone: "America/New_York"
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (start_time + 1.hour).iso8601,
        time_zone: "America/New_York"
      ),
      conference_data: Google::Apis::CalendarV3::ConferenceData.new(
        create_request: Google::Apis::CalendarV3::CreateConferenceRequest.new(
          request_id: SecureRandom.uuid,
          conference_solution_key: Google::Apis::CalendarV3::ConferenceSolutionKey.new(
            type: "hangoutsMeet"
          )
        )
      )
    )

    result = calendar.insert_event("primary", event, conference_data_version: 1)
    result.hangout_link # Returns meet.google.com/xxx-xxxx-xxx
  rescue Google::Apis::Error => e
    Rails.logger.error "Google Calendar API Error: #{e.message}"
    nil
  end

  private

  def authorize_user
    # This assumes you have OAuth tokens stored for the user
    # For now, using service account or user's stored credentials
    authorizer = Google::Auth::UserAuthorizer.new(
      Google::Auth::ClientId.from_file(Rails.root.join("config", "google_client_secret.json")),
      Google::Apis::CalendarV3::AUTH_CALENDAR,
      Google::Auth::Stores::FileTokenStore.new(file: Rails.root.join("tmp", "tokens.yaml"))
    )

    authorizer.get_credentials(@user.email_address)
  end
end
