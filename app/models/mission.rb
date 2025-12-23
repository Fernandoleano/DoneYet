class Mission < ApplicationRecord
  belongs_to :meeting
  belongs_to :agent, class_name: "User"

  has_many :mission_comments, dependent: :destroy
  has_many :mission_assignments, dependent: :destroy
  has_many :assigned_users, through: :mission_assignments, source: :user
  has_many_attached :attachments

  enum :status, { pending: 0, done: 1, canceled: 2 }, default: :pending
  enum :dispatch_status, { pending: 0, sent: 1, failed: 2 }, default: :pending, prefix: :dispatch
  enum :difficulty, { easy: 0, medium: 1, hard: 2, critical: 3 }, default: :medium, prefix: :difficulty
  enum :threat_level, { low: 0, medium: 1, high: 2, critical: 3 }, default: :medium, prefix: :threat

  validates :title, presence: true
  validates :due_at, presence: true

  after_update :award_completion_xp, if: :saved_change_to_status?

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

  # Time tracking methods
  def start_timer!
    update(
      is_timer_running: true,
      timer_started_at: Time.current
    )
    # Set started_at only if it's the first time
    update(started_at: Time.current) unless started_at
  end

  def pause_timer!
    return unless is_timer_running && timer_started_at

    elapsed = Time.current - timer_started_at
    update(
      time_tracked_seconds: time_tracked_seconds + elapsed.to_i,
      is_timer_running: false,
      timer_started_at: nil
    )
  end

  def stop_timer!
    pause_timer! if is_timer_running
    update(status: :done, completed_at: Time.current)
  end

  def current_timer_duration
    return 0 unless is_timer_running && timer_started_at
    Time.current - timer_started_at
  end

  def total_time_tracked
    base = time_tracked_seconds || 0
    base + current_timer_duration.to_i
  end

  def formatted_time_tracked
    total = total_time_tracked
    hours = total / 3600
    minutes = (total % 3600) / 60
    seconds = total % 60

    if hours > 0
      "#{hours}h #{minutes}m"
    elsif minutes > 0
      "#{minutes}m #{seconds}s"
    else
      "#{seconds}s"
    end
  end

  private

  def award_completion_xp
    return unless done? && agent.user_stat

    base_xp = xp_reward || 100
    bonus_xp = calculate_bonus_xp
    total_xp = base_xp + bonus_xp

    agent.user_stat.add_xp(total_xp, reason: "Completed: #{title}")
    agent.user_stat.increment!(:missions_completed)

    check_achievements
  end

  def calculate_bonus_xp
    bonus = 0

    # Early completion bonus
    if completed_at && completed_at < due_at
      hours_early = ((due_at - completed_at) / 1.hour).round
      bonus += [ hours_early * 5, 50 ].min
    end

    # Difficulty multiplier
    case difficulty
    when :difficulty_hard
      bonus += 50
    when :difficulty_critical
      bonus += 100
    end

    bonus
  end

  def check_achievements
    # First mission
    if agent.user_stat.missions_completed == 1
      Achievement.check_and_award(agent, "first_mission")
    end

    # Speed demon (completed in under 1 hour)
    if completed_at && created_at && (completed_at - created_at) < 1.hour
      Achievement.check_and_award(agent, "speed_demon")
    end

    # Early completion
    if completed_at && completed_at < due_at
      Achievement.check_and_award(agent, "early_bird")
    end

    # Mission milestones
    case agent.user_stat.missions_completed
    when 10
      Achievement.check_and_award(agent, "mission_veteran")
    when 50
      Achievement.check_and_award(agent, "mission_expert")
    when 100
      Achievement.check_and_award(agent, "century_club")
    end
  end
end
