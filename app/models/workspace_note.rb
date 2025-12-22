class WorkspaceNote < ApplicationRecord
  belongs_to :workspace

  validates :content, presence: true

  NOTE_TYPES = {
    "priority" => "📌",
    "reminder" => "🎯",
    "achievement" => "⭐",
    "general" => "📝"
  }.freeze

  scope :recent, -> { order(created_at: :desc) }

  def icon
    NOTE_TYPES[note_type] || "📝"
  end
end
