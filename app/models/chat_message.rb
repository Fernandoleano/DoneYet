class ChatMessage < ApplicationRecord
  belongs_to :channel
  belongs_to :user
  belongs_to :parent_message, class_name: "ChatMessage", optional: true
  has_many :replies, class_name: "ChatMessage", foreign_key: "parent_message_id", dependent: :destroy
  has_many_attached :attachments

  validates :content, presence: true

  scope :recent, -> { order(created_at: :asc) }
  scope :root_messages, -> { where(parent_message_id: nil) }
end
