class LandingController < ApplicationController
  skip_before_action :authenticate, only: [ :index ]
  layout "landing"

  def index
  end
end
