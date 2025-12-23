class FeatureRequest < ApplicationRecord
  has_many :feature_votes, dependent: :destroy
  has_many :users, through: :feature_votes
end
