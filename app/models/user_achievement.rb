class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  validates :user_id, uniqueness: { scope: :achievement_id }

  scope :recent, -> { order(unlocked_at: :desc) }
end
