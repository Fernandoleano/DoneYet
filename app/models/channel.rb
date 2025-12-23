class Channel < ApplicationRecord
  belongs_to :workspace
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  has_many :channel_memberships, dependent: :destroy
  has_many :members, through: :channel_memberships, source: :user
  has_many :chat_messages, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :workspace_id }
  validates :name, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }

  scope :public_channels, -> { where(private: false, is_direct_message: false) }
  scope :private_channels, -> { where(private: true, is_direct_message: false) }
  scope :direct_messages, -> { where(is_direct_message: true) }

  # Find or create a DM channel between two users
  def self.find_or_create_dm(user1, user2, workspace)
    # Sort user IDs to ensure consistent naming
    ids = [ user1.id, user2.id ].sort
    dm_name = "dm_#{ids.join('_')}"

    channel = workspace.channels.find_by(name: dm_name, is_direct_message: true)

    unless channel
      channel = workspace.channels.create!(
        name: dm_name,
        description: "Direct message between #{user1.name} and #{user2.name}",
        private: true,
        is_direct_message: true,
        created_by: user1
      )
      channel.add_member(user1)
      channel.add_member(user2)
    end

    channel
  end

  def display_name
    if is_direct_message?
      # For DMs, this will be overridden in the view to show the partner's name
      "Direct Message"
    else
      "##{name}"
    end
  end

  # Get the other user in a DM (for the current user)
  def dm_partner(current_user)
    return nil unless is_direct_message?
    members.where.not(id: current_user.id).first
  end

  # Get display name for a specific user (shows partner's name in DMs)
  def display_name_for(user)
    if is_direct_message?
      partner = dm_partner(user)
      partner ? partner.name : "Direct Message"
    else
      "##{name}"
    end
  end

  def add_member(user)
    members << user unless members.include?(user)
  end

  def remove_member(user)
    members.delete(user)
  end
end
