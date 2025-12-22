class Achievement < ApplicationRecord
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true

  TIERS = %w[bronze silver gold platinum diamond].freeze
  CATEGORIES = %w[mission collaboration streak briefing speed].freeze

  scope :by_category, ->(category) { where(category: category) }
  scope :by_tier, ->(tier) { where(tier: tier) }

  def self.check_and_award(user, achievement_key)
    achievement = find_by(key: achievement_key)
    return unless achievement

    unless user.user_achievements.exists?(achievement: achievement)
      user.user_achievements.create!(
        achievement: achievement,
        unlocked_at: Time.current
      )

      # Award XP
      user.user_stat.add_xp(achievement.xp_reward, reason: "Achievement: #{achievement.name}")

      # TODO: Broadcast achievement notification
      Rails.logger.info "🏆 #{user.name} unlocked: #{achievement.name}"

      true
    else
      false
    end
  end
end
