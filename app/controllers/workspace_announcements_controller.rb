class WorkspaceAnnouncementsController < ApplicationController
  def index
    @announcements = Current.user.workspace.workspace_announcements.pinned_first.includes(:user, :announcement_reads)
    @unread_count = @announcements.count - @announcements.select { |a| a.read_by?(Current.user) }.count
  end

  def create
    # Only captains can create announcements
    unless Current.user.captain?
      redirect_to workspace_announcements_path, alert: "Only captains can create announcements"
      return
    end

    @announcement = Current.user.workspace.workspace_announcements.build(announcement_params)
    @announcement.user = Current.user

    if @announcement.save
      redirect_to workspace_announcements_path, notice: "Announcement posted!"
    else
      redirect_to workspace_announcements_path, alert: "Failed to post announcement: #{@announcement.errors.full_messages.join(', ')}"
    end
  end

  def mark_as_read
    @announcement = Current.user.workspace.workspace_announcements.find(params[:id])
    @announcement.mark_as_read_by(Current.user)

    respond_to do |format|
      format.html { redirect_to workspace_announcements_path }
      format.json { head :ok }
    end
  end

  def toggle_pin
    unless Current.user.captain?
      redirect_to workspace_announcements_path, alert: "Only captains can pin announcements"
      return
    end

    @announcement = Current.user.workspace.workspace_announcements.find(params[:id])
    @announcement.update(pinned: !@announcement.pinned)

    redirect_to workspace_announcements_path, notice: @announcement.pinned? ? "Announcement pinned" : "Announcement unpinned"
  end

  def destroy
    unless Current.user.captain?
      redirect_to workspace_announcements_path, alert: "Only captains can delete announcements"
      return
    end

    @announcement = Current.user.workspace.workspace_announcements.find(params[:id])
    @announcement.destroy

    redirect_to workspace_announcements_path, notice: "Announcement deleted"
  end

  private

  def announcement_params
    params.require(:workspace_announcement).permit(:title, :content, :priority, attachments: [])
  end
end
