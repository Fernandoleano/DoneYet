class MissionCommentsController < ApplicationController
  before_action :set_mission

  def create
    @comment = @mission.mission_comments.build(comment_params)
    @comment.user = Current.user

    if @comment.save
      redirect_to @mission, notice: "Comment added!"
    else
      redirect_to @mission, alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end

  def comment_params
    params.require(:mission_comment).permit(:content, attachments: [])
  end
end
