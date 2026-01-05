# script/manual_upgrade.rb
email = "leanofernando884@gmail.com"
user = User.find_by(email_address: email)

if user
  puts "✅ Found User: #{user.email_address}"
  workspace = user.workspace

  if workspace
    puts "   Workspace: #{workspace.name} (ID: #{workspace.id})"
    puts "   Current Status: #{workspace.subscription_status}"
    puts "   Current Plan: #{workspace.plan_type}"

    # Perform Upgrade
    workspace.update!(
      plan_type: 'pro',
      subscription_status: 'active',
      stripe_customer_id: 'manually_upgraded_by_admin',
      stripe_subscription_id: 'manual_override'
    )
    puts "🚀 UPGRADE COMPLETE: Workspace is now PRO."
  else
    puts "❌ User has no workspace!"
  end
else
  puts "❌ User '#{email}' not found."
  # List recent users just in case
  puts "Recent users:"
  User.order(created_at: :desc).limit(5).each do |u|
    puts " - #{u.email_address} (Created: #{u.created_at})"
  end
end
