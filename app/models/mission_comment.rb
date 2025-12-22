class MissionComment < ApplicationRecord
  belongs_to :mission
  belongs_to :user
  has_many_attached :attachments

  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
