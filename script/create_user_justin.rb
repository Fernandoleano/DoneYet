# Usage: rails runner script/create_user_justin.rb

puts "🚀 Starting user provisioning for Justin Jacobs..."

email = "jjacobs@askhpm.com"
name = "Justin Jacobs"
password = "password"

# 1. Find or Create Workspace
# Users must belong to a workspace. We'll create a personal one for him.
workspace_name = "Justin Jacobs Workspace"
workspace = Workspace.find_or_create_by!(name: workspace_name) do |w|
  w.plan_type = "pro" # Give the workspace Pro status too, just in case
  w.subscription_status = :active
  puts "✅ Created new workspace: #{w.name}"
end

# 2. Find or Create User
user = User.find_or_initialize_by(email_address: email)

user.name = name
if user.new_record?
  user.password = password
  user.password_confirmation = password
  user.workspace = workspace
  puts "📝 Configuring new user..."
else
  puts "ℹ️ User already exists. Updating permissions..."
end

# 3. Grant Beta/Pro Access
user.beta_user = true
user.role = "agent" # Default role, but ensuring it is set

# 4. Save
if user.save
  puts "🎉 Success! User '#{user.email_address}' is ready."
  puts "   - Beta User (Pro Access): #{user.beta_user}"
  puts "   - Workspace: #{user.workspace.name}"
else
  puts "❌ Failed to save user:"
  user.errors.full_messages.each { |msg| puts "   - #{msg}" }
end
