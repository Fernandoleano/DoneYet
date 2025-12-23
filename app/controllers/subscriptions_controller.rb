class SubscriptionsController < ApplicationController
  before_action :require_authentication

  def index
    @workspace = current_workspace
  end

  def create_checkout_session
    @workspace = current_workspace

    # Create or retrieve Stripe customer
    customer = if @workspace.stripe_customer_id.present?
      Stripe::Customer.retrieve(@workspace.stripe_customer_id)
    else
      customer = Stripe::Customer.create(
        email: current_user.email_address,
        metadata: {
          workspace_id: @workspace.id,
          workspace_name: @workspace.name
        }
      )
      @workspace.update(stripe_customer_id: customer.id)
      customer
    end

    # Create Checkout Session
    session = Stripe::Checkout::Session.create(
      customer: customer.id,
      mode: "subscription",
      payment_method_types: [ "card" ],
      line_items: [ {
        price_data: {
          currency: "usd",
          product_data: {
            name: "DoneYet Pro",
            description: "Unlimited team members, advanced analytics, priority support"
          },
          recurring: {
            interval: "month"
          },
          unit_amount: 1200 # $12.00 in cents
        },
        quantity: 1
      } ],
      success_url: success_subscriptions_url,
      cancel_url: subscriptions_url,
      metadata: {
        workspace_id: @workspace.id
      }
    )

    redirect_to session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    redirect_to subscriptions_path, alert: "Payment error: #{e.message}"
  end

  def success
    @workspace = current_workspace
    flash[:notice] = "Welcome to DoneYet Pro! Your subscription is now active."
  end

  def cancel
    @workspace = current_workspace

    if @workspace.stripe_subscription_id.blank?
      redirect_to subscriptions_path, alert: "No active subscription found."
      return
    end

    begin
      Stripe::Subscription.cancel(@workspace.stripe_subscription_id)
      flash[:notice] = "Your subscription has been canceled. You'll retain access until the end of your billing period."
    rescue Stripe::StripeError => e
      flash[:alert] = "Error canceling subscription: #{e.message}"
    end

    redirect_to subscriptions_path
  end

  private
end
