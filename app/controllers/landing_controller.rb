class LandingController < ApplicationController
  allow_unauthenticated_access
  layout "landing"

  def index
    # Redirect authenticated users to their dashboard
    redirect_to meetings_path if Current.session
  end
end
