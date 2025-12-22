class Meeting < ApplicationRecord
  belongs_to :workspace
  belongs_to :captain, class_name: "User"
  has_many :missions, dependent: :destroy

  enum :status, { briefing: 0, dispatched: 1, closed: 2 }, default: :briefing

  validates :title, presence: true
  validates :meet_code, uniqueness: { allow_nil: true }
  validate :meet_code_format, if: -> { meet_code.present? }

  before_validation :normalize_meet_code

  def meet_url
    return nil unless meet_code.present?
    "https://meet.google.com/#{meet_code}"
  end

  private

  def normalize_meet_code
    return unless meet_code.present?
    # Extract just the code from full URL (e.g., "meet.google.com/abc-defg-hij" → "abc-defg-hij")
    self.meet_code = meet_code.to_s.gsub(/https?:\/\/(meet\.google\.com\/)?/, "").strip
  end

  def meet_code_format
    # Google Meet codes are in format: xxx-xxxx-xxx (3-4-3 characters, letters/numbers)
    # Example: abc-defg-hij
    unless meet_code.match?(/\A[a-z]{3}-[a-z]{4}-[a-z]{3}\z/)
      errors.add(:meet_code, "is not a valid Google Meet code (format: abc-defg-hij)")
    end
  end
end
