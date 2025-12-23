class FeatureRequestsController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    @features = FeatureRequest.order(votes_count: :desc)
    @new_feature = FeatureRequest.new
  end

  def create
    @feature = FeatureRequest.new(feature_params)
    if @feature.save
      redirect_to feature_requests_path, notice: "Feature request submitted successfully."
    else
      @features = FeatureRequest.order(votes_count: :desc)
      @new_feature = @feature # Preserve errors
      render :index, status: :unprocessable_entity
    end
  end

  def upvote
    @feature = FeatureRequest.find(params[:id])

    if Current.user && !@feature.feature_votes.exists?(user: Current.user)
      if @feature.feature_votes.create(user: Current.user)
        @feature.increment!(:votes_count)
        redirect_to feature_requests_path, notice: "Upvoted!"
      else
        redirect_to feature_requests_path, alert: "Could not register vote."
      end
    else
      redirect_to feature_requests_path, alert: "You have already voted for this feature."
    end
  end

  private

  def feature_params
    params.require(:feature_request).permit(:title, :description)
  end
end
