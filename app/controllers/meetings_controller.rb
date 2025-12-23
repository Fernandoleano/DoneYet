class MeetingsController < ApplicationController
  def index
    @meetings = Current.user.workspace.meetings.order(created_at: :desc)
    @active_meetings = @meetings.where(status: :dispatched)
    @overdue_missions = Current.user.workspace.missions.pending.where("due_at < ?", Time.current)

    # Mission statistics for charts
    all_missions = Current.user.workspace.missions
    @total_missions = all_missions.count
    @completed_missions = all_missions.done.count
    @pending_missions = all_missions.pending.count
    @in_progress_missions = all_missions.where.not(started_at: nil).where(status: :pending).count

    # Weekly activity data
    @weekly_data = (6.days.ago.to_date..Date.today).map do |date|
      {
        date: date.strftime("%a"),
        completed: all_missions.done.where("DATE(completed_at) = ?", date).count
      }
    end

    # HQ Notes
    @workspace_notes = Current.user.workspace.workspace_notes.recent.limit(5)
  end

  def new
    @meeting = Current.user.workspace.meetings.new
  end

  def create
    @meeting = Current.user.workspace.meetings.new(meeting_params)
    @meeting.captain = Current.user

    if @meeting.save
      ahoy.track "Created Briefing", meeting_id: @meeting.id, title: @meeting.title
      redirect_to @meeting
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @meeting = Current.user.workspace.meetings.find(params[:id])
    @missions = @meeting.missions.includes(:agent).order(created_at: :asc)
  end

  def dispatch_meeting
    @meeting = Current.user.workspace.meetings.find(params[:id])

    unless Current.user.workspace.active_subscription?
       redirect_to subscriptions_path, alert: "You must upgrade to dispatch missions."
       return
    end

    if MeetingDispatcher.new(@meeting).call
      ahoy.track "Dispatched Briefing", meeting_id: @meeting.id
      redirect_to @meeting, notice: "Briefing dispatched! Agents are being notified."
    else
      redirect_to @meeting, alert: "Could not dispatch: #{@meeting.errors.full_messages.to_sentence}"
    end
  end

  def meet
    if params[:code]
      @meeting = Current.user.workspace.meetings.find_or_create_by(meet_code: params[:code]) do |m|
        m.title = "Meet Briefing #{Date.today}"
        m.captain = Current.user
      end
    elsif params[:id]
      @meeting = Current.user.workspace.meetings.find(params[:id])
    end

    @missions = @meeting.missions.includes(:agent).order(created_at: :asc)
    render layout: "meet"
  end

  def simulator
    @meeting = Current.user.workspace.meetings.find(params[:id])
    ahoy.track "Opened Simulator", meeting_id: @meeting.id
  end

  private

  def meeting_params
    params.require(:meeting).permit(:title, :meet_code)
  end
end
