class ChatMessagesController < ApplicationController
  def create
    @channel = Current.user.workspace.channels.find(params[:channel_id])
    @message = @channel.chat_messages.build(message_params)
    @message.user = Current.user

    if @message.save
      redirect_to channel_path(@channel)
    else
      redirect_to channel_path(@channel), alert: "Failed to send message"
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content, attachments: [])
  end
end
