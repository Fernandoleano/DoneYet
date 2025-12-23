class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  after_action :track_action

  helper_method :current_workspace, :current_user_has_full_access?, :feature_available?

  protected

  def current_workspace
    current_user&.workspace
  end

  def current_user_has_full_access?
    current_user&.has_full_access?
  end

  def feature_available?(feature)
    current_user&.can_access_feature?(feature)
  end

  def require_pro_access!
    unless current_user_has_full_access?
      redirect_to subscriptions_path, alert: "This feature requires a Pro subscription."
    end
  end

  def track_action
    ahoy.track "Viewed #{controller_name}##{action_name}", request.path_parameters.to_h
  end
end
