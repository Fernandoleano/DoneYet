Rails.application.config.to_prepare do
  MissionControl::Jobs::Engine.routes.default_url_options = Rails.application.config.action_mailer.default_url_options
  MissionControl::Jobs.base_controller_class = "ApplicationController"
  MissionControl::Jobs::ApplicationController.skip_before_action :authenticate_by_http_basic
end
