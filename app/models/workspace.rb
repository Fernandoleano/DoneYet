class Workspace < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_many :missions, through: :meetings
  has_many :integrations, dependent: :destroy
  has_many :automations, dependent: :destroy
  has_many :workspace_notes, dependent: :destroy
  has_many :workspace_announcements, dependent: :destroy
  has_many :channels, dependent: :destroy

  validates :name, presence: true

  enum :subscription_status, { trial: 0, active: 1, past_due: 2, canceled: 3 }, default: :trial
  enum :plan_type, { free: 0, pro: 1 }, default: :free

  def active_subscription?
    active? || trial?
  end

  def pro?
    plan_type == "pro" && active_subscription?
  end

  def max_members
    pro? ? Float::INFINITY : 5
  end

  def can_add_member?
    users.count < max_members
  end

  # Slack Integration
  def slack_connected?
    slack_team_id.present? && slack_access_token.present?
  end

  def disconnect_slack!
    update(
      slack_team_id: nil,
      slack_team_name: nil,
      slack_access_token: nil,
      slack_bot_token: nil,
      slack_webhook_url: nil,
      slack_connected_at: nil
    )
  end

  def slack_client
    return nil unless slack_connected?

    @slack_client ||= Slack::Web::Client.new(token: slack_bot_token)
  end
end
