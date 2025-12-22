class NotificationsController < ApplicationController
  def index
    @pending_missions = Current.user.workspace.missions.pending.includes(:agent, :meeting).order(due_at: :asc)
    @overdue_missions = @pending_missions.where("due_at < ?", Time.current)
  end
end
