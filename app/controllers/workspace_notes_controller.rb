class WorkspaceNotesController < ApplicationController
  def create
    @note = Current.user.workspace.workspace_notes.build(note_params)

    if @note.save
      redirect_to root_path, notice: "HQ Note added!"
    else
      redirect_to root_path, alert: "Failed to add note: #{@note.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @note = Current.user.workspace.workspace_notes.find(params[:id])
    @note.destroy
    redirect_to root_path, notice: "HQ Note deleted!"
  end

  private

  def note_params
    params.require(:workspace_note).permit(:content, :note_type)
  end
end
