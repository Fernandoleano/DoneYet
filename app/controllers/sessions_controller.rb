class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }
  layout "auth"

  def new
  end

  def create
    Rails.logger.info "LOGIN ATTEMPT: Email=#{params[:email_address].inspect}"

    # Strip whitespace from password to prevent copy-paste errors
    password_param = params[:password]&.strip

    if user = User.authenticate_by(email_address: params[:email_address], password: password_param)
      Rails.logger.info "LOGIN SUCCESS: User=#{user.id}"
      start_new_session_for user
      ahoy.authenticate(user)

      # Handle remember me
      if params[:remember_me] == "1"
        cookies.permanent.signed[:user_id] = user.id
      end

      redirect_to after_authentication_url
    else
      Rails.logger.info "LOGIN FAILED: Invalid credentials for #{params[:email_address]}"
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
