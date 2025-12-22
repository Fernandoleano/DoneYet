class LandingController < ApplicationController
  layout "landing"

  def index
    # Redirect authenticated users to their dashboard
    redirect_to meetings_path if Current.user
  end
end
