class UserStat < ApplicationRecord
  belongs_to :user

  RANKS = {
    1..5 => "🎓 Recruit",
    6..10 => "🕵️ Field Agent",
    11..20 => "🎖️ Senior Agent",
    21..35 => "💼 Operative",
    36..50 => "⭐ Commander",
    51..Float::INFINITY => "👑 Director"
  }.freeze

  after_create :generate_code_name

  def add_xp(amount, reason: nil)
    self.total_xp += amount
    check_level_up
    save

    # TODO: Broadcast notification for XP gain
    Rails.logger.info "#{user.name} earned #{amount} XP#{reason ? " for: #{reason}" : ''}"
  end

  def check_level_up
    new_level = calculate_level(total_xp)
    if new_level > level
      old_level = level
      self.level = new_level
      self.rank = calculate_rank(new_level)

      # TODO: Broadcast level up notification
      Rails.logger.info "#{user.name} leveled up! #{old_level} → #{new_level} (#{rank})"
    end
  end

  def calculate_level(xp)
    # Formula: level = sqrt(xp / 100) + 1
    Math.sqrt(xp / 100.0).floor + 1
  end

  def calculate_rank(level)
    RANKS.find { |range, _| range.include?(level) }&.last || "👑 Director"
  end

  def xp_for_next_level
    next_level_xp = (level ** 2) * 100
    next_level_xp - total_xp
  end

  def progress_to_next_level
    current_level_xp = ((level - 1) ** 2) * 100
    next_level_xp = (level ** 2) * 100
    total_needed = next_level_xp - current_level_xp
    current_progress = total_xp - current_level_xp

    return 0 if total_needed <= 0
    [ (current_progress.to_f / total_needed * 100).round, 100 ].min
  end

  def update_streak
    today = Date.current

    if last_login_date == today
      # Already logged in today
      return
    elsif last_login_date == today - 1.day
      # Consecutive day
      self.current_streak += 1
      self.longest_streak = [ longest_streak, current_streak ].max
    else
      # Streak broken
      self.current_streak = 1
    end

    self.last_login_date = today
    save

    # Award streak XP
    add_xp(10, reason: "Daily login streak (#{current_streak} days)")
  end

  private

  def generate_code_name
    self.code_name = CodeNameGenerator.generate
    save
  end
end
