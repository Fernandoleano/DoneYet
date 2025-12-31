class AdminController < ApplicationController
  before_action :ensure_admin!, except: [ :stop_impersonating ]

  def index
    @total_users = User.count
    @total_workspaces = Workspace.count
    @total_missions = Mission.count
    @total_meetings = Meeting.count
    @total_messages = ChatMessage.count

    @recent_users = User.order(created_at: :desc).limit(10)
    @recent_workspaces = Workspace.order(created_at: :desc).limit(10)
    @active_missions = Mission.where(status: :pending).count
    @completed_missions = Mission.where(status: :done).count

    # Recent activity stats
    @users_this_week = User.where("created_at >= ?", 1.week.ago).count
    @missions_this_week = Mission.where("created_at >= ?", 1.week.ago).count
  end

  def users
    @users = User.includes(:workspace, :user_stat).order(created_at: :desc)
  end

  def workspaces
    @workspaces = Workspace.includes(:users, :missions, :meetings).order(created_at: :desc)
  end

  def impersonate
    user = User.find(params[:id])
    session[:impersonating_user_id] = user.id
    session[:admin_user_id] = Current.user.id
    redirect_to root_path, notice: "Now impersonating #{user.name}"
  end

  def stop_impersonating
    # Clear the impersonation session variables
    session.delete(:impersonating_user_id)
    admin_user_id = session.delete(:admin_user_id)

    # Clear Current.session so it gets reloaded
    Current.session = nil

    redirect_to admin_path, notice: "Stopped impersonating"
  end

  private

  def ensure_admin!
    # Only allow fernandoleano4@gmail.com to access admin
    unless Current.user&.email_address == "fernandoleano4@gmail.com"
      redirect_to root_path, alert: "Access denied"
    end
  end
end
