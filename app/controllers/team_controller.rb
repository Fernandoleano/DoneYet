class TeamController < ApplicationController
  def index
    # Shows all workspace members
  end

  def invite
    email = params[:email]
    name = params[:name]

    # Check if user already exists
    existing_user = User.find_by(email_address: email)

    if existing_user
      # Add to workspace if not already a member
      if Current.user.workspace.users.include?(existing_user)
        redirect_to team_index_path, alert: "#{email} is already in your workspace"
      else
        Current.user.workspace.users << existing_user
        redirect_to team_index_path, notice: "#{name} added to your workspace!"
      end
    else
      # Create new user and add to workspace
      password = SecureRandom.hex(8)
      user = User.create!(
        email_address: email,
        name: name,
        password: password,
        password_confirmation: password,
        workspace: Current.user.workspace
      )

      # TODO: Send invite email with password reset link
      redirect_to team_index_path, notice: "Invite sent to #{email}! (Password: #{password})"
    end
  rescue => e
    redirect_to team_index_path, alert: "Error: #{e.message}"
  end
end
