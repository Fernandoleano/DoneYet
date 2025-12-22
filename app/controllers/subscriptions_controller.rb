class SubscriptionsController < ApplicationController
  def index
  end

  def create
    price_id = "price_1Q..." # Placeholder - in real app, use ENV variable

    session = Stripe::Checkout::Session.create({
      success_url: success_subscriptions_url,
      cancel_url: subscriptions_url,
      customer_email: Current.user.email_address,
      line_items: [
        { price: price_id, quantity: 1 }
      ],
      mode: "subscription",
      subscription_data: {
        metadata: {
          workspace_id: Current.user.workspace.id
        }
      }
    })

    redirect_to session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    redirect_to subscriptions_path, alert: "Payment error: #{e.message}"
  end

  def success
    # In a real app, don't rely only on this. Webhooks are source of truth.
    # For MVP UX, we might provision here optimistically or just say "Thanks".
    Current.user.workspace.update(subscription_status: :active)
    redirect_to root_path, notice: "Subscription active! You can now dispatch missions."
  end
end
