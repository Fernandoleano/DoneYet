class Mission < ApplicationRecord
  belongs_to :meeting
  belongs_to :agent, class_name: "User"

  has_many :mission_comments, dependent: :destroy
  has_many :mission_assignments, dependent: :destroy
  has_many :assigned_users, through: :mission_assignments, source: :user
  has_many_attached :attachments

  enum :status, { pending: 0, done: 1, canceled: 2 }, default: :pending
  enum :dispatch_status, { pending: 0, sent: 1, failed: 2 }, default: :pending, prefix: :dispatch

  validates :title, presence: true
  validates :due_at, presence: true

  def completed?
    done?
  end

  def current_stage
    return "completed" if done?
    return "in_progress" if started_at.present?
    "dispatched"
  end

  def stage_completed?(stage)
    case stage
    when "dispatched"
      true # Always true after mission is created
    when "in_progress"
      started_at.present? || done?
    when "completed"
      done?
    end
  end

  def stage_timestamp(stage)
    case stage
    when "dispatched"
      created_at
    when "in_progress"
      started_at
    when "completed"
      completed_at
    end
  end
end
