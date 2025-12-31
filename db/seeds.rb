workspace = Workspace.create!(name: "Acme Corp")
captain = User.create!(
  workspace: workspace,
  email_address: "captain@acme.com",
  password: "password",
  password_confirmation: "password",
  name: "Captain John",
  role: :captain
)
puts "Created Captain: #{captain.email_address}"

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create achievements
achievements = [
  # Mission Achievements
  {
    key: 'first_mission',
    name: '🎯 License to Complete',
    description: 'Complete your first mission',
    icon: '🎯',
    xp_reward: 100,
    category: 'mission',
    tier: 'bronze'
  },
  {
    key: 'speed_demon',
    name: '⚡ Speed Demon',
    description: 'Complete a mission in under 1 hour',
    icon: '⚡',
    xp_reward: 150,
    category: 'speed',
    tier: 'silver'
  },
  {
    key: 'early_bird',
    name: '🌅 Early Bird',
    description: 'Complete a mission before the deadline',
    icon: '🌅',
    xp_reward: 75,
    category: 'mission',
    tier: 'bronze'
  },
  {
    key: 'mission_veteran',
    name: '🎖️ Mission Veteran',
    description: 'Complete 10 missions',
    icon: '🎖️',
    xp_reward: 200,
    category: 'mission',
    tier: 'silver'
  },
  {
    key: 'mission_expert',
    name: '⭐ Mission Expert',
    description: 'Complete 50 missions',
    icon: '⭐',
    xp_reward: 500,
    category: 'mission',
    tier: 'gold'
  },
  {
    key: 'century_club',
    name: '💯 Century Club',
    description: 'Complete 100 missions',
    icon: '💯',
    xp_reward: 1000,
    category: 'mission',
    tier: 'platinum'
  },
  {
    key: 'team_player',
    name: '🤝 Team Player',
    description: 'Collaborate on 10 missions',
    icon: '🤝',
    xp_reward: 200,
    category: 'collaboration',
    tier: 'silver'
  },
  {
    key: 'communicator',
    name: '💬 Communicator',
    description: 'Post 100 comments',
    icon: '💬',
    xp_reward: 250,
    category: 'collaboration',
    tier: 'gold'
  },
  {
    key: 'strategist',
    name: '📋 Strategist',
    description: 'Create 10 briefings',
    icon: '📋',
    xp_reward: 200,
    category: 'briefing',
    tier: 'silver'
  },
  {
    key: 'master_planner',
    name: '🎯 Master Planner',
    description: 'Create 50 briefings',
    icon: '🎯',
    xp_reward: 500,
    category: 'briefing',
    tier: 'gold'
  },
  {
    key: 'dedicated_agent',
    name: '📅 Dedicated Agent',
    description: '7 day login streak',
    icon: '📅',
    xp_reward: 100,
    category: 'streak',
    tier: 'bronze'
  },
  {
    key: 'unstoppable',
    name: '🔥 Unstoppable',
    description: '30 day login streak',
    icon: '🔥',
    xp_reward: 500,
    category: 'streak',
    tier: 'gold'
  }
]

achievements.each do |achievement_data|
  Achievement.find_or_create_by!(key: achievement_data[:key]) do |achievement|
    achievement.assign_attributes(achievement_data)
  end
end

puts "✅ Created #{Achievement.count} achievements"

# Create user stats for existing users without them
User.find_each do |user|
  unless user.user_stat
    user.create_user_stat!
    puts "✅ Created user_stat for #{user.name}"
  end
end

agent = User.create!(
  workspace: workspace,
  email_address: "agent@acme.com",
  password: "password",
  password_confirmation: "password",
  name: "Agent Sarah",
  role: :agent
)
puts "Created Agent: #{agent.email_address}"

admin = User.create!(
  workspace: workspace,
  email_address: "fernandoleano4@gmail.com",
  password: "password",
  password_confirmation: "password",
  name: "Fernando Leano",
  role: :captain
)
puts "Created Admin: #{admin.email_address}"
