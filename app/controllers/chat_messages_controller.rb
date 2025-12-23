class ChatMessagesController < ApplicationController
  def create
    @channel = Current.user.workspace.channels.find(params[:channel_id])
    @message = @channel.chat_messages.build(message_params)
    @message.user = Current.user

    if @message.save
      ahoy.track "Sent Message", channel_id: @channel.id, message_id: @message.id

      if @message.content.include?("giphy.com")
        ahoy.track "Sent GIF", channel_id: @channel.id, message_id: @message.id
      end

      redirect_to channel_path(@channel)
    else
      redirect_to channel_path(@channel), alert: "Failed to send message"
    end
  end

  def update
    @message = ChatMessage.find(params[:id])

    if @message.user == Current.user && @message.update(content: params[:chat_message][:content])
      redirect_to channel_path(@message.channel), notice: "Message updated!"
    else
      redirect_to channel_path(@message.channel), alert: "Failed to update message."
    end
  end

  def destroy
    @message = ChatMessage.find(params[:id])

    if @message.user == Current.user
      @message.destroy
      redirect_to channel_path(@message.channel), notice: "Message deleted!"
    else
      redirect_to channel_path(@message.channel), alert: "You can only delete your own messages."
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content, attachments: [])
  end
end
