class MissionControlController < ApplicationController
  layout "mission_control"
  before_action :ensure_solo_agent

  def index
    # Mock data for now, matching the design
    @rank = "CMDR"
    @success_rate = 94
    @intel_available = true

    # Critical missions mock data
    @missions = [
      { name: "Extract Asset", location: "Berlin, Sector 4", t_minus: 45.minutes, threat: "Critical" },
      { name: "Surveillance", location: "Casino Royale", t_minus: 12.hours, threat: "High" },
      { name: "Dead Drop", location: "Prague Station", t_minus: 24.hours, threat: "Low" }
    ]

    @coordinates = { lat: "48.2°N", lng: "16.3°E" }
  end

  private

  def ensure_solo_agent
    if Current.user.nil?
      redirect_to new_session_path, alert: "Authentication required."
      # elsif !Current.user.solo?
      #   redirect_to meetings_path, alert: "Access denied. Section reserved for Solo Agents."
    end
  end
end
