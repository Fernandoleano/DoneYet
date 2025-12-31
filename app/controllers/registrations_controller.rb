class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  layout "auth"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Create workspace with custom name
    workspace_name = params[:user][:workspace_name].presence || "#{@user.name}'s Workspace"
    @user.workspace = Workspace.create!(name: workspace_name)

    if @user.save
      start_new_session_for @user
      ahoy.authenticate(@user)

      if params[:user_type] == "solo"
        @user.update(user_type: :solo)
        # Update workspace name to include user name now that we have it
        @user.workspace.update(name: "#{@user.name}'s HQ")
        redirect_to mission_control_path, notice: "Welcome, Agent #{@user.name}. Mission Control is online."
      else
        @user.update(user_type: :team)
        redirect_to root_path, notice: "Welcome to DoneYet!"
      end
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email_address, "is already taken")
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :role)
  end
end
