class ProfileController < ApplicationController
  def show
    @user = Current.user
    @user_stat = @user.user_stat || @user.create_user_stat
    @achievements = @user.user_achievements.includes(:achievement).order(unlocked_at: :desc)
  end
end
