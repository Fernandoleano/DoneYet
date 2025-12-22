class Mission < ApplicationRecord
  belongs_to :meeting
  belongs_to :agent, class_name: "User"

  enum :status, { pending: 0, done: 1, canceled: 2 }, default: :pending
  enum :dispatch_status, { pending: 0, sent: 1, failed: 2 }, default: :pending, prefix: :dispatch

  validates :title, presence: true
  validates :due_at, presence: true

  def completed?
    done?
  end
end
