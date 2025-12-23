class FeatureVote < ApplicationRecord
  belongs_to :feature_request
  belongs_to :user
end
