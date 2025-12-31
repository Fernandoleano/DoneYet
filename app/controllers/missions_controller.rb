class MissionsController < ApplicationController
  before_action :set_meeting, only: [ :create, :destroy ]

  def index
    @missions = Current.user.workspace.missions.order(due_at: :asc)

    # Filter Logic
    case params[:filter]
    when "done"
      @missions = @missions.done
      @page_title = "Completed Missions"
    when "active"
      @missions = @missions.pending.where("due_at >= ?", Time.current)
      @page_title = "Active Missions"
    when "overdue"
      @missions = @missions.pending.where("due_at < ?", Time.current)
      @page_title = "Overdue Missions"
    else
      @page_title = "All Missions"
    end
  end

  def show
    @mission = Mission.find(params[:id])
    ensure_agent_access!
  end

  def edit
    @mission = Mission.find(params[:id])
    ensure_agent_access!
  end

  def update
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    if @mission.update(mission_params_full)
      # Track status change timestamps
      case @mission.status
      when "done"
        @mission.update(completed_at: Time.current) unless @mission.completed_at
        @mission.update(started_at: Time.current) unless @mission.started_at
        ahoy.track "Completed Mission", mission_id: @mission.id, title: @mission.title
      end

      ahoy.track "Updated Mission", mission_id: @mission.id, status: @mission.status
      redirect_to @mission, notice: "Mission updated!"
    else
      render :edit, alert: "Could not update mission."
    end
  end

  def mark_in_progress
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    @mission.update(started_at: Time.current) unless @mission.started_at
    ahoy.track "Started Mission", mission_id: @mission.id
    redirect_to @mission, notice: "Mission started!"
  end

  def create
    @mission = @meeting.missions.new(mission_params)

    if @mission.save
      ahoy.track "Created Mission", mission_id: @mission.id, title: @mission.title, meeting_id: @meeting.id
      redirect_to @meeting
    else
      redirect_to @meeting, alert: "Failed to create mission: #{@mission.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @mission = @meeting.missions.find(params[:id])
    @mission.destroy
    redirect_to @meeting
  end

  def start_timer
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    @mission.start_timer!
    ahoy.track "Started Timer", mission_id: @mission.id
    redirect_to @mission, notice: "Timer started!"
  end

  def pause_timer
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    @mission.pause_timer!
    ahoy.track "Paused Timer", mission_id: @mission.id, duration: @mission.time_tracked_seconds
    redirect_to @mission, notice: "Timer paused!"
  end

  def stop_timer
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    @mission.stop_timer!
    ahoy.track "Stopped Timer", mission_id: @mission.id, total_time: @mission.time_tracked_seconds
    redirect_to @mission, notice: "Mission completed! Timer stopped."
  end

  private

  def ensure_agent_access!
    unless @mission.agent == Current.user || @mission.meeting.captain == Current.user
      redirect_to root_path, alert: "Access denied."
    end
  end

  def set_meeting
    @meeting = Current.user.workspace.meetings.find(params[:meeting_id])
  end

  def mission_params_update
    params.require(:mission).permit(:status)
  end

  def mission_params_full
    params.require(:mission).permit(:title, :description, :due_at, :status, :agent_id, assigned_user_ids: [], attachments: [])
  end

  def mission_params
    params.require(:mission).permit(:title, :agent_id, :due_at)
  end
end
