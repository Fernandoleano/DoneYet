require_relative "../../lib/resend_delivery_method"

Rails.application.reloader.to_prepare do
  ActionMailer::Base.add_delivery_method :resend_api, ResendDeliveryMethod, api_key: ENV["RESEND_API_KEY"]
end
