class AnnouncementRead < ApplicationRecord
  belongs_to :workspace_announcement
  belongs_to :user

  validates :user_id, uniqueness: { scope: :workspace_announcement_id }

  before_create :set_read_at

  private

  def set_read_at
    self.read_at ||= Time.current
  end
end
