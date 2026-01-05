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

      TeamInvitationMailer.invite(user, Current.user, password).deliver_later
      redirect_to team_index_path, notice: "Invite sent to #{email}! Please advise them to check their spam folder. (Password: #{password})"
    end
  rescue => e
    redirect_to team_index_path, alert: "Error: #{e.message}"
  end

  def promote
    target_user = User.find(params[:id])

    # Authorization Checks
    unless Current.user.captain?
      return redirect_to team_index_path, alert: "Unauthorized: Only the Captain can transfer command."
    end

    if target_user.workspace_id != Current.user.workspace_id
      return redirect_to team_index_path, alert: "Target outside jurisdiction."
    end

    if target_user == Current.user
      return redirect_to team_index_path, alert: "You are already the Captain."
    end

    User.transaction do
      # 1. Promote target to Captain
      target_user.update!(role: :captain)

      # 2. Demote current user to Agent
      Current.user.update!(role: :agent)
    end

    redirect_to team_index_path, notice: "Command transferred. You are now an Agent reporting to Captain #{target_user.name}."
  rescue => e
    redirect_to team_index_path, alert: "Transfer failed: #{e.message}"
  end

  def destroy
    user = User.find(params[:id])

    # Authorization Check
    unless Current.user.captain?
      return redirect_to team_index_path, alert: "Unauthorized: Only Captains can remove agents."
    end

    if user == Current.user
      return redirect_to team_index_path, alert: "Protocol Violation: You cannot remove yourself."
    end

    if user.workspace_id != Current.user.workspace_id
      return redirect_to team_index_path, alert: "Target outside jurisdiction."
    end

    user.destroy
    redirect_to team_index_path, notice: "Agent #{user.name} has been disavowed and removed from the unit."
  end
end
