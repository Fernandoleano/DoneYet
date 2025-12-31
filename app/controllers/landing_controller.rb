class LandingController < ApplicationController
  allow_unauthenticated_access
  layout "landing"

  def index
    # Redirect authenticated users to their dashboard
    if cookies.signed[:session_id].present? && (user = Current.user)
      if user.solo?
        redirect_to mission_control_path
      else
        redirect_to meetings_path
      end
    end
  end

  def contact
  end

  def privacy
  end

  def terms
  end
end
