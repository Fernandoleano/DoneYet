# Usage: bin/rails runner script/debug_access.rb

puts "--- Debugging Access Control ---"

users = User.includes(:workspace).all

users.each do |user|
  ws = user.workspace
  puts "\nUser: #{user.email_address} (#{user.name})"
  puts "  Role: #{user.role}"
  puts "  Beta User?: #{user.try(:beta_user?)}" rescue "N/A"

  if ws
    puts "  Workspace: #{ws.name} (ID: #{ws.id})"
    puts "  Plan Type: #{ws.plan_type}"
    puts "  Sub Status: #{ws.subscription_status}"
    puts "  Active Sub?: #{ws.active_subscription?}"
    puts "  Pro?: #{ws.pro?}"
    puts "  Members: #{ws.users.count}"
    puts "  Invited Users: #{ws.users.where.not(id: user.id).pluck(:email_address).join(', ')}"
  else
    puts "  Workspace: NIL"
  end

  puts "  Has Full Access?: #{user.has_full_access?}"
  puts "    -> Reason: Admin? #{user.email_address == 'fernandoleano4@gmail.com'} | Beta? #{user.try(:beta_user?)} | WS Pro? #{ws&.pro?}"
end

puts "\n--- End Debug ---"
