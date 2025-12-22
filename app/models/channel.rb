class Channel < ApplicationRecord
  belongs_to :workspace
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  has_many :channel_memberships, dependent: :destroy
  has_many :members, through: :channel_memberships, source: :user
  has_many :chat_messages, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :workspace_id }
  validates :name, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }

  scope :public_channels, -> { where(private: false) }
  scope :private_channels, -> { where(private: true) }

  def display_name
    "##{name}"
  end

  def add_member(user)
    members << user unless members.include?(user)
  end

  def remove_member(user)
    members.delete(user)
  end
end
