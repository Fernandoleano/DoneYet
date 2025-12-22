class MissionsController < ApplicationController
  before_action :set_meeting, only: [ :create, :destroy ]

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
      end

      redirect_to @mission, notice: "Mission updated!"
    else
      render :edit, alert: "Could not update mission."
    end
  end

  def mark_in_progress
    @mission = Mission.find(params[:id])
    ensure_agent_access!

    @mission.update(started_at: Time.current) unless @mission.started_at
    redirect_to @mission, notice: "Mission started!"
  end

  def create
    @mission = @meeting.missions.new(mission_params)

    if @mission.save
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
