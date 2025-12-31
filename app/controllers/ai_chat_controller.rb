class AiChatController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!

  def query
    begin
      # Rate Limiting
      key = "chat_limit:#{current_user.id}:#{Time.current.beginning_of_hour.to_i}"
      count = Rails.cache.read(key) || 0
      limit = current_user_has_full_access? ? 50 : 10

      if count >= limit
        render json: {
          status: "success",
          message: "🚫 USAGE LIMIT REACHED\n\nYou have used #{count}/#{limit} commands this hour.\n\nFree Plan: 10/hr\nPro Plan: 50/hr\n\n[Upgrade to Pro](/subscriptions) to continue."
        }
        return
      end

      Rails.cache.write(key, count + 1, expires_in: 1.hour)

      service = AiCommandService.new(current_user, params[:query], params[:context])
      result = service.call
      render json: result
    rescue => e
      puts "AI CHAT ERROR: #{e.message}"
      puts e.backtrace.join("\n")
      render json: { status: "error", message: "Server Error: #{e.message}" }, status: 500
    end
  end
end
