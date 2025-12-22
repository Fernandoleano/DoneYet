class ChannelsController < ApplicationController
  def index
    @channels = Current.user.workspace.channels.order(created_at: :asc)

    # Create default channels if none exist
    if @channels.empty?
      general = Current.user.workspace.channels.create!(
        name: "general",
        description: "General team discussion",
        private: false,
        created_by: Current.user
      )

      random = Current.user.workspace.channels.create!(
        name: "random",
        description: "Random chatter",
        private: false,
        created_by: Current.user
      )

      # Auto-join all workspace users to default channels
      Current.user.workspace.users.each do |user|
        general.add_member(user)
        random.add_member(user)
      end

      @channels = Current.user.workspace.channels.order(created_at: :asc)
    end

    # Redirect to first channel
    redirect_to channel_path(@channels.first) if @channels.any?
  end

  def show
    @channel = Current.user.workspace.channels.find(params[:id])
    @channels = Current.user.workspace.channels.order(created_at: :asc)
    @messages = @channel.chat_messages.includes(:user).recent
    @new_message = ChatMessage.new

    # Auto-join user if not a member
    @channel.add_member(Current.user) unless @channel.members.include?(Current.user)
  end

  def create
    @channel = Current.user.workspace.channels.build(channel_params)
    @channel.created_by = Current.user

    if @channel.save
      @channel.add_member(Current.user)
      redirect_to channel_path(@channel), notice: "Channel created!"
    else
      redirect_to channels_path, alert: "Failed to create channel: #{@channel.errors.full_messages.join(', ')}"
    end
  end

  private

  def channel_params
    params.require(:channel).permit(:name, :description, :private)
  end
end
