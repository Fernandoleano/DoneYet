class LandingController < ApplicationController
  skip_before_action :authenticate, only: [ :index ]
  layout "landing"

  def index
    # Redirect authenticated users to their dashboard
    redirect_to meetings_path if Current.user
  end
end
