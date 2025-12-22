class Automation < ApplicationRecord
  belongs_to :workspace

  enum :automation_type, {
    recurring_meeting: 0,
    reminder_schedule: 1,
    integration_trigger: 2
  }

  validates :name, presence: true
  validates :automation_type, presence: true
  validates :config, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :due, -> { enabled.where("next_run_at <= ?", Time.current) }

  def execute!
    case automation_type
    when "recurring_meeting"
      execute_recurring_meeting
    when "reminder_schedule"
      execute_reminder_schedule
    when "integration_trigger"
      execute_integration_trigger
    end

    update(last_run_at: Time.current, next_run_at: calculate_next_run)
  end

  def calculate_next_run
    return nil unless enabled?

    case automation_type
    when "recurring_meeting"
      calculate_recurring_meeting_next_run
    when "reminder_schedule"
      calculate_reminder_schedule_next_run
    when "integration_trigger"
      nil # Triggers run on events, not schedule
    end
  end

  def should_run?
    enabled? && next_run_at.present? && next_run_at <= Time.current
  end

  private

  def execute_recurring_meeting
    # Create a new meeting based on template
    # This would be implemented with actual meeting creation logic
  end

  def execute_reminder_schedule
    # Send reminders based on configuration
    # This would be implemented with actual reminder logic
  end

  def execute_integration_trigger
    # Send to integration (Slack, Email, etc.)
    # This would be implemented with actual integration logic
  end

  def calculate_recurring_meeting_next_run
    frequency = config["frequency"]
    case frequency
    when "daily"
      1.day.from_now
    when "weekly"
      1.week.from_now
    when "monthly"
      1.month.from_now
    else
      nil
    end
  end

  def calculate_reminder_schedule_next_run
    # Calculate based on intervals
    intervals = config["intervals"] || []
    return nil if intervals.empty?

    intervals.first.hours.from_now
  end
end
