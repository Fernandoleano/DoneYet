class WorkspaceAnnouncement < ApplicationRecord
  belongs_to :workspace
  belongs_to :user
  has_many :announcement_reads, dependent: :destroy
  has_many_attached :attachments

  enum :priority, { normal: 0, important: 1, urgent: 2 }, default: :normal

  validates :title, presence: true
  validates :content, presence: true

  scope :pinned_first, -> { order(pinned: :desc, created_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  def read_by?(user)
    announcement_reads.exists?(user: user)
  end

  def mark_as_read_by(user)
    announcement_reads.find_or_create_by(user: user) do |read|
      read.read_at = Time.current
    end
  end

  def unread_count
    workspace.users.count - announcement_reads.count
  end
end
