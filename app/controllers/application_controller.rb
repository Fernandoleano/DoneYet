class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  after_action :track_action

  protected

  def track_action
    ahoy.track "Viewed #{controller_name}##{action_name}", request.path_parameters.to_h
  end
end
