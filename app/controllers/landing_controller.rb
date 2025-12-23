class LandingController < ApplicationController
  allow_unauthenticated_access
  layout "landing"

  def index
    # Redirect authenticated users to their dashboard
    if cookies.signed[:session_id].present?
      redirect_to meetings_path
    end
  end

  def contact
  end

  def privacy
  end

  def terms
  end
end
