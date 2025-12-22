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

  def active_subscription?
    active? || trial?
  end
end
