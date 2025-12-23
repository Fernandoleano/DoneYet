class ChannelsController < ApplicationController
  layout "chat"

  def index
    @workspace = Current.user.workspace
    ensure_default_channels

    # Separate regular channels and DMs
    @channels = @workspace.channels.public_channels.order(:name)
    @direct_messages = @workspace.channels.direct_messages
                                 .joins(:channel_memberships)
                                 .where(channel_memberships: { user_id: Current.user.id })
                                 .distinct
                                 .order(updated_at: :desc)
    @workspace_members = @workspace.users.where.not(id: Current.user.id)

    # Redirect to first available channel or DM
    if @channels.any?
      redirect_to channel_path(@channels.first)
    elsif @direct_messages.any?
      redirect_to channel_path(@direct_messages.first)
    end
  end

  def show
    @channel = Channel.find(params[:id])
    @workspace = @channel.workspace

    # Access Control
    if @channel.private? || @channel.is_direct_message?
      unless @channel.members.include?(Current.user)
        redirect_to channels_path, alert: "You are not authorized to access this channel."
        return
      end
    else
      # Auto-join public channels
      unless @channel.members.include?(Current.user)
        @channel.add_member(Current.user)
      end
    end

    @messages = @channel.chat_messages.includes(:user).order(created_at: :asc)
    @new_message = @channel.chat_messages.build

    # Load all channels and DMs for sidebar
    @channels = @workspace.channels.public_channels.order(:name)
    @direct_messages = @workspace.channels.direct_messages
                                 .joins(:channel_memberships)
                                 .where(channel_memberships: { user_id: Current.user.id })
                                 .distinct
                                 .order(updated_at: :desc)
    @workspace_members = @workspace.users.where.not(id: Current.user.id)
  end

  def start_dm
    other_user = User.find(params[:user_id])
    @workspace = Current.user.workspace

    # Find or create DM channel
    dm_channel = Channel.find_or_create_dm(Current.user, other_user, @workspace)

    redirect_to channel_path(dm_channel)
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

  def ensure_default_channels
    return if @workspace.channels.public_channels.any?

    general = @workspace.channels.create!(
      name: "general",
      description: "General team discussion",
      private: false,
      created_by: Current.user
    )

    random = @workspace.channels.create!(
      name: "random",
      description: "Random chatter",
      private: false,
      created_by: Current.user
    )

    # Auto-join all workspace users to default channels
    @workspace.users.each do |user|
      general.add_member(user)
      random.add_member(user)
    end
  end

  def channel_params
    params.require(:channel).permit(:name, :description, :private)
  end
end
