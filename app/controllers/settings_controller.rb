class SettingsController < ApplicationController
  def index
    @user = Current.user
    @workspace = Current.user.workspace
  end

  def update
    @user = Current.user

    if params[:user]
      if @user.update(user_params)
        redirect_to settings_path, notice: "Profile updated successfully!"
      else
        render :index, status: :unprocessable_entity
      end
    elsif params[:workspace]
      @workspace = Current.user.workspace
      if @workspace.update(workspace_params)
        redirect_to settings_path, notice: "Workspace updated successfully!"
      else
        render :index, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :avatar)
  end

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
