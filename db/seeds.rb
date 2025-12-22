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

agent = User.create!(
  workspace: workspace,
  email_address: "agent@acme.com",
  password: "password",
  password_confirmation: "password",
  name: "Agent Sarah",
  role: :agent
)
puts "Created Agent: #{agent.email_address}"
