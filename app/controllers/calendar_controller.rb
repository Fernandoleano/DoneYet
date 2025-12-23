class CalendarController < ApplicationController
  before_action :require_pro_access!

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @date.beginning_of_month.beginning_of_week(:sunday)
    @end_date = @date.end_of_month.end_of_week(:sunday)

    # Fetch missions for the month
    @missions = Current.user.workspace.missions
      .where(due_at: @start_date..@end_date)
      .includes(:agent, :meeting)

    # Fetch meetings for the month
    @meetings = Current.user.workspace.meetings
      .where(created_at: @start_date..@end_date)
      .includes(:captain)

    # Group by date
    @missions_by_date = @missions.group_by { |m| m.due_at.to_date }
    @meetings_by_date = @meetings.group_by { |m| m.created_at.to_date }
  end
end
